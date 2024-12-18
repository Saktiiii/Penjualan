<?php
class M_penjualan extends CI_Model
{
    // Fungsi untuk mendapatkan daftar penjualan dengan filter dan pagination
    function list($row_no, $row_per_page, $no_faktur, $nama_pelanggan, $tgl_mulai, $tgl_akhir)
    {
        $this->db->select('no_faktur, tgltransaksi, kode_pelanggan, nama_pelanggan, jenistransaksi, jatuhtempo, id_user, nama_lengkap, total_jual, total_bayar, sisa');
        $this->db->from('v_total_penjualan');
        $this->db->limit($row_per_page, $row_no);

        if (!empty($no_faktur)) {
            $this->db->where('no_faktur', $no_faktur);
        }
        if (!empty($nama_pelanggan)) {
            $this->db->like('nama_pelanggan', $nama_pelanggan);
        }
        if (!empty($tgl_mulai)) {
            $this->db->where('tgltransaksi >=', $tgl_mulai);
        }
        if (!empty($tgl_akhir)) {
            $this->db->where('tgltransaksi <=', $tgl_akhir);
        }
        
        return $this->db->get();
    }

    

    // Fungsi untuk mendapatkan penjualan hari ini
    function listtoday()
    {
        $today = date("Y-m-d");

        if ($this->session->userdata('kode_cabang') != 'PST') {
            $this->db->where('users.kode_cabang', $this->session->userdata('kode_cabang'));
        }

        $this->db->join('users', 'penjualan.id_user = users.id_user');
        return $this->db->get_where('penjualan', array('tgltransaksi' => $today));
    }

    // Fungsi untuk menghitung total pembayaran hari ini
    function resulttoday()
    {
        $today = date("Y-m-d");
        $this->db->select("SUM(bayar) as tot_paid");
        $this->db->from("historibayar");
        $this->db->join("penjualan", "historibayar.no_faktur = penjualan.no_faktur");
        $this->db->join("users", "users.id_user = penjualan.id_user");
        $this->db->where("tglbayar", $today);
        return $this->db->get();
    }

    // Fungsi untuk menyimpan data penjualan
    function insert($data)
    {
        // Simpan data penjualan ke tabel penjualan
        $penjualan_saved = $this->db->insert('penjualan', $data);
        if (!$penjualan_saved) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Gagal menyimpan data penjualan!</div>');
            redirect('penjualan/input');
            return;
        }
    
        $no_faktur = $data['no_faktur'];
        $id_user = $data['id_user'];
        $jenis_transaksi = $data['jenistransaksi'];
        $tgltransaksi = $data['tgltransaksi'];
    
        // Ambil detail penjualan dari tabel sementara
        $detail_penjualan = $this->db->get_where('penjualan_detail_temp', array('id_user' => $id_user))->result();
        if (empty($detail_penjualan)) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Detail penjualan kosong!</div>');
            redirect('penjualan/input');
            return;
        }
    
        // Periksa stok setiap barang di tabel barang_harga
        foreach ($detail_penjualan as $d) {
            $kode_barang = $d->kode_barang;
    
            // Ambil stok barang berdasarkan kode_barang dari tabel barang_harga
            $stok_barang = $this->db->select('stok')
                ->from('barang_harga')
                ->where('kode_barang', $kode_barang) // Kode barang saja, tidak perlu kode_cabang
                ->get()
                ->row();
    
            if (!$stok_barang || $stok_barang->stok < $d->qty) {
                $this->session->set_flashdata('msg', '<div class="alert alert-danger">Stok barang tidak mencukupi!</div>');
                redirect('penjualan/input');
                return;
            }
        }
    
        // Proses simpan detail penjualan
        $total_harga = 0;
        foreach ($detail_penjualan as $d) {
            $total_harga += ($d->qty * $d->harga);
            $data_detail = array(
                'no_faktur' => $no_faktur,
                'kode_barang' => $d->kode_barang,
                'harga' => $d->harga,
                'qty' => $d->qty
            );
    
            if (!$this->db->insert('penjualan_detail', $data_detail)) {
                $this->db->delete('penjualan', array('no_faktur' => $no_faktur));
                $this->session->set_flashdata('msg', '<div class="alert alert-danger">Gagal menyimpan detail penjualan!</div>');
                redirect('penjualan/input');
                return;
            }
    
            // Update stok barang di tabel barang_harga
            $this->db->set('stok', 'stok - ' . (int)$d->qty, FALSE)
                ->where('kode_barang', $d->kode_barang)
                ->update('barang_harga');
        }
    
        // Update total harga pada tabel penjualan
        $this->db->update('penjualan', ['total_harga' => $total_harga], ['no_faktur' => $no_faktur]);
    
        // Hapus data sementara
        $this->db->delete('penjualan_detail_temp', array('id_user' => $id_user));
    
        // Jika transaksi cash, simpan historibayar
        if ($jenis_transaksi === 'cash') {
            $this->process_cash_payment($tgltransaksi, $total_harga, $no_faktur, $id_user);
        }
    }
    

    // Fungsi untuk memproses pembayaran cash
    private function process_cash_payment($tgl_transaksi, $total_harga, $no_faktur, $id_user)
    {
        $tahun = date('Y');
        $thn = substr($tahun, 2, 2);

        $getLastNoBukti = $this->db->query("SELECT nobukti FROM historibayar WHERE YEAR(tglbayar) = '$tahun' ORDER BY nobukti DESC LIMIT 1")->row_array();
        $nomorterakhir = $getLastNoBukti ? $getLastNoBukti['nobukti'] : $thn . '000000';
        $nobukti = buatkode($nomorterakhir, $thn, 6);

        $databayar = array(
            'nobukti' => $nobukti,
            'no_faktur' => $no_faktur,
            'tglbayar' => $tgl_transaksi,
            'bayar' => $total_harga,
            'id_user' => $id_user
        );

        if (!$this->db->insert('historibayar', $databayar)) {
            $this->db->delete('penjualan_detail', array('no_faktur' => $no_faktur));
            $this->db->delete('penjualan', array('no_faktur' => $no_faktur));
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Gagal menyimpan pembayaran!</div>');
            redirect('penjualan/input');
            return;
        }
    }

    // Fungsi lainnya tetap seperti sebelumnya...


    function delete($no_faktur)
    {
        $deleted = $this->db->delete('penjualan', array('no_faktur' => $no_faktur));
        if ($deleted) {
            $detail_deleted = $this->db->delete('penjualan_detail', array('no_faktur' => $no_faktur));
            if ($detail_deleted) {
                $this->session->set_flashdata('msg', '<div class="alert alert-success" role="alert">Deleting successfully</div>');
                redirect('penjualan');
            }
        }
    }

    function get($no_faktur)
    {
        $this->db->select('penjualan.no_faktur, tgltransaksi, penjualan.kode_pelanggan, nama_pelanggan, alamat_pelanggan, jenistransaksi, penjualan.jatuhtempo, penjualan.id_user, nama_lengkap as cashier');
        $this->db->from('penjualan');
        $this->db->join('pelanggan', 'penjualan.kode_pelanggan = pelanggan.kode_pelanggan');
        $this->db->join('users', 'penjualan.id_user = users.id_user');
        $this->db->where('penjualan.no_faktur', $no_faktur);
        return $this->db->get();
    }

    function get_detail($no_faktur)
    {
        $this->db->select('penjualan_detail.kode_barang, nama_barang, penjualan_detail.harga, qty, satuan');
        $this->db->from('penjualan_detail');
        $this->db->join('barang_master', 'penjualan_detail.kode_barang = barang_master.kode_barang');
        $this->db->where('penjualan_detail.no_faktur', $no_faktur);
        return $this->db->get();
    }

    function get_rows($no_faktur, $nama_pelanggan, $tgl_mulai, $tgl_akhir)
    {
        $this->db->select('no_faktur, tgltransaksi, kode_pelanggan, nama_pelanggan, jenistransaksi, jatuhtempo, id_user, nama_lengkap, total_jual, total_bayar, sisa');
        $this->db->from('v_total_penjualan');
        if ($no_faktur != '') {
            $this->db->where('no_faktur', $no_faktur);
        }
        if ($nama_pelanggan != '') {
            $this->db->like('nama_pelanggan', $nama_pelanggan);
        }
        if ($tgl_mulai != '') {
            $this->db->where('tgltransaksi >=', $tgl_mulai);
        }
        if ($tgl_akhir != '') {
            $this->db->where('tgltransaksi <=', $tgl_akhir);
        }
        return $this->db->get();
    }



    function cek_barang()
    {
        $id_user = $this->session->userdata('id_user');
        return $this->db->get_where('penjualan_detail_temp', array('id_user' => $id_user));
    }

    function get_last_invoice_no($bulan, $tahun, $cabang)
    {
        $this->db->select('no_faktur');
        $this->db->from('penjualan');
        $this->db->join('users', 'penjualan.id_user = users.id_user');
        $this->db->where('kode_cabang', $cabang);
        $this->db->where('MONTH(tgltransaksi)', $bulan);
        $this->db->where('YEAR(tgltransaksi)', $tahun);
        $this->db->order_by('no_faktur', 'desc');
        $this->db->limit(1);

        return $this->db->get();
    }



    function is_temp_exist($kode_barang, $id_user)
    {
        return $this->db->get_where('penjualan_detail_temp', array('kode_barang' => $kode_barang, 'id_user' => $id_user));
    }

    function insert_temp($data)
    {
        $this->db->insert('penjualan_detail_temp', $data);
    }

    function get_temp($id_user)
    {
        $this->db->select('penjualan_detail_temp.kode_barang, nama_barang, harga, qty, (qty * harga) as total, id_user');
        $this->db->from('penjualan_detail_temp');
        $this->db->join('barang_master', 'penjualan_detail_temp.kode_barang = barang_master.kode_barang');
        $this->db->where('id_user', $id_user);
        return $this->db->get();
    }

    function delete_temp($kode_barang, $id_user)
    {
        $deleted = $this->db->delete('penjualan_detail_temp', array('kode_barang' => $kode_barang, 'id_user' => $id_user));
        if ($deleted) {
            return 1;
        }
    }

    function get_reportdata($cabang, $tgl_mulai, $tgl_akhir)
    {
        if ($cabang != "") {
            $this->db->where('kode_cabang', $cabang);
        }
        $this->db->where('tgltransaksi >=', $tgl_mulai);
        $this->db->where('tgltransaksi <=', $tgl_akhir);
        $this->db->select('no_faktur, tgltransaksi, kode_pelanggan, nama_pelanggan, jenistransaksi, jatuhtempo, id_user, nama_lengkap, total_jual, total_bayar, sisa');
        $this->db->from('v_total_penjualan');
        return $this->db->get();
    }

    function get_monthlysale()
    {
        $tahun = date("Y");
        $cabang = $this->session->userdata('kode_cabang');

        if ($cabang == 'PST') {
            $sql = "SELECT b.id, b.bulan, j.tahun, j.sale FROM bulan AS b"
                . " LEFT JOIN ("
                . " SELECT YEAR(h.tgltransaksi) as tahun, MONTH(h.tgltransaksi) AS bulan, SUM(d.harga * d.qty) AS sale"
                . " FROM penjualan_detail AS d"
                . " INNER JOIN penjualan AS h ON d.no_faktur = h.no_faktur "
                . " INNER JOIN users AS u ON h.id_user = u.id_user"
                . " WHERE YEAR(h.tgltransaksi) = $tahun "
                . " GROUP BY YEAR(h.tgltransaksi), MONTH(h.tgltransaksi) "
                . " ) as j ON (b.id = j.bulan)";
        } else {
            $sql = "SELECT b.id, b.bulan, j.tahun, j.sale FROM bulan AS b"
                . " LEFT JOIN ("
                . " SELECT YEAR(h.tgltransaksi) as tahun, MONTH(h.tgltransaksi) AS bulan, SUM(d.harga * d.qty) AS sale"
                . " FROM penjualan_detail AS d"
                . " INNER JOIN penjualan AS h ON d.no_faktur = h.no_faktur "
                . " INNER JOIN users AS u ON h.id_user = u.id_user"
                . " WHERE YEAR(h.tgltransaksi) = $tahun AND u.kode_cabang = '$cabang'"
                . " GROUP BY YEAR(h.tgltransaksi), MONTH(h.tgltransaksi) "
                . " ) as j ON (b.id = j.bulan)";
        }
        return $this->db->query($sql);
    }

}
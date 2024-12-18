<?php

function penyebut($nilai) {
    $nilai = abs($nilai); // Pastikan nilainya positif
    $huruf = array("", "satu", "dua", "tiga", "empat", "lima", "enam", "tujuh", "delapan", "sembilan", "sepuluh", "sebelas");
    $temp = "";
    if ($nilai < 12) {
        $temp = " " . $huruf[$nilai];
    } else if ($nilai < 20) {
        $temp = penyebut($nilai - 10) . " belas";
    } else if ($nilai < 100) {
        $temp = penyebut(floor($nilai / 10)) . " puluh" . penyebut($nilai % 10);
    } else if ($nilai < 200) {
        $temp = " seratus" . penyebut($nilai - 100);
    } else if ($nilai < 1000) {
        $temp = penyebut(floor($nilai / 100)) . " ratus" . penyebut($nilai % 100);
    } else if ($nilai < 2000) {
        $temp = " seribu" . penyebut($nilai - 1000);
    } else if ($nilai < 1000000) {
        $temp = penyebut(floor($nilai / 1000)) . " ribu" . penyebut($nilai % 1000);
    } else if ($nilai < 1000000000) {
        $temp = penyebut(floor($nilai / 1000000)) . " juta" . penyebut($nilai % 1000000);
    } else if ($nilai < 1000000000000) {
        $temp = penyebut(floor($nilai / 1000000000)) . " milyar" . penyebut(fmod($nilai, 1000000000));
    } else if ($nilai < 1000000000000000) {
        $temp = penyebut(floor($nilai / 1000000000000)) . " trilyun" . penyebut(fmod($nilai, 1000000000000));
    }
    return $temp;
}

function terbilang($nilai) {
    $hasil = "";

    // Tangani bilangan negatif
    if ($nilai < 0) {
        $hasil = "minus " . trim(penyebut(abs($nilai)));
    } else {
        // Pisahkan bilangan bulat dan desimal
        $nilai = (string)$nilai;
        $parts = explode('.', $nilai);
        $bilangan_bulat = (int)$parts[0]; // Bagian sebelum desimal
        $hasil = trim(penyebut($bilangan_bulat));

        // Tangani bilangan desimal (jika ada)
        if (isset($parts[1])) {
            $hasil .= " koma";
            foreach (str_split($parts[1]) as $digit) {
                $hasil .= " " . penyebut((int)$digit);
            }
        }
    }

    return $hasil;
}
?>

<?php
session_start();

$idioma = $_SESSION['idioma'] ?? 'es';

$ruta = "lenguajes/$idioma.php";
if (!file_exists($ruta)) {
    $ruta = "lenguajes/es.php";
}

$lang = include $ruta;

/**
 * Función para obtener traducciones
 */
function __($texto) {
    global $lang;
    return $lang[$texto] ?? $texto;
}
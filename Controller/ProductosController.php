<?php
include_once $_SERVER["DOCUMENT_ROOT"] . "/FideTechnology/Model/ProductosModel.php";

if ($_SESSION['usuario']['rol'] !== 'admin') {
      header('Location: ?controlador=Login&accion=accesoDenegado');
      exit;

function ConsultarProductos()
{
    return ConsultarProductosModel();
}
?>

<?php include_once 'View/estructura/layoutInterno.php'; ?>

<div class="container">
    <h2><?php echo __('Mi Cuenta'); ?></h2>
    <form action="?controlador=Login&accion=actualizarMiCuenta" method="post">
        <div class="form-group">
            <label><?php echo __('Nombre'); ?></label>
            <input type="text" name="nombre" value="<?php echo $_SESSION['usuario']['nombre']; ?>" required>
        </div>
        <div class="form-group">
            <label><?php echo __('Dirección de envío'); ?></label>
            <input type="text" name="direccion" value="<?php echo $_SESSION['usuario']['direccion']; ?>" required>
        </div>
        <div class="form-group">
            <label><?php echo __('Teléfono de contacto'); ?></label>
            <input type="text" name="telefono" value="<?php echo $_SESSION['usuario']['telefono']; ?>" required>
        </div>
        <button type="submit"><?php echo __('Guardar Cambios'); ?></button>
    </form>
</div>

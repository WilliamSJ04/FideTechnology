CREATE DATABASE IF NOT EXISTS `fidetechnology` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `fidetechnology`;

-- Table structure for table `perfil`
DROP TABLE IF EXISTS `perfil`;
CREATE TABLE `perfil` (
  `Id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table `perfil`
LOCK TABLES `perfil` WRITE;
INSERT INTO `perfil` VALUES (1,'Cliente(a)'),(2,'Administrador(a)'),(3,'Vendedor(a)');
UNLOCK TABLES;

-- Table structure for table `productos`
DROP TABLE IF EXISTS `productos`;
CREATE TABLE `productos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(255) NOT NULL,
  `Descripcion` text NOT NULL,
  `Precio` decimal(10,2) NOT NULL,
  `Imagen` varchar(255) NOT NULL,
  `Disponibilidad` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table `productos`
LOCK TABLES `productos` WRITE;
INSERT INTO `productos` VALUES 
(1,'Samsung Galaxy S22','Telefono con Lapiz',999.99,'https://www.cqnetcr.com/114602-thickbox_default/celular-samsung-galaxy-s22-ultra-amoled-2x-blanco.jpg',1),
(2,'iPhone 13','Bordes de Titanio',1099.99,'https://www.tiendaamiga.com.bo/media/catalog/product/cache/deb88dadd509903c96aaa309d3e790dc/e/0/e06641-iphone-13-bolivia.jpg',1),
(3,'Xiaomi Mi 11','Gama Media',799.99,'https://cyberteamcr.com/wp-content/uploads/2024/11/17201_12930.jpg',1),
(4,'Honor 50','Gama Media',799.99,'https://www.elgallomasgallo.com.gt/media/catalog/product/c/e/celular-4g-honor-x6a-plus-purpura-128gb-190444_3_.jpg?optimize=medium&bg-color=255,255,255&fit=bounds&height=700&width=700&canvas=700:700',0),
(5,'iPhone 16 Plus','Bordes de Titanio',900.99,'https://phonesstorekenya.com/wp-content/uploads/2024/02/Apple-iPhone-16-Plus.jpg',1),
(6,'Samsung Flip 3','Telefono Plegable',1200.99,'https://phlexxgadgets.co.ke/wp-content/uploads/2024/08/Samsung-Galaxy-Z-Flip-3-Price-in-Kenya-003-Mobilehub-Kenya.jpg',0);
UNLOCK TABLES;

-- Table structure for table `usuario` with added rol column
DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
  `Id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(250) NOT NULL,
  `Correo` varchar(100) NOT NULL,
  `Contrasenna` varchar(15) NOT NULL,
  `Activacion` varchar(64) DEFAULT NULL,
  `IdPerfil` bigint(20) NOT NULL,
  `rol` varchar(20) DEFAULT 'cliente',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Uk_Correo` (`Correo`),
  UNIQUE KEY `Uk_Activacion` (`Activacion`),
  KEY `FK_UsuarioPerfil` (`IdPerfil`),
  CONSTRAINT `FK_UsuarioPerfil` FOREIGN KEY (`IdPerfil`) REFERENCES `perfil` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table `usuario` with sample roles
LOCK TABLES `usuario` WRITE;
INSERT INTO `usuario` VALUES 
(1,'Fernando chacon zuñiga','chaconzunigafernando@gmail.com','F1603','fb82a4c3b232b84935c216819702636d8a6b94dfef59f9342b90e422274689d4',1,'admin'),
(2,'Vendedor Ejemplo','vendedor@example.com','vendor123',3,NULL,'vendedor'),
(3,'Cliente Ejemplo','cliente@example.com','client123',1,NULL,'cliente');
UNLOCK TABLES;

-- Updated stored procedures with role support

-- SP_ActivarCuenta
DROP PROCEDURE IF EXISTS `SP_ActivarCuenta`;
DELIMITER ;;
CREATE PROCEDURE `SP_ActivarCuenta`(
    IN p_idUsuario INT
)
BEGIN
    UPDATE usuario 
    SET Activacion = NULL
    WHERE Id = p_idUsuario;
END ;;
DELIMITER ;

-- SP_ActualizarContrasenna
DROP PROCEDURE IF EXISTS `SP_ActualizarContrasenna`;
DELIMITER ;;
CREATE PROCEDURE `SP_ActualizarContrasenna`(
    pId bigint(20),
    pCodigo varchar(6)
)
BEGIN
    UPDATE usuario
    SET Contrasenna = pCodigo
    WHERE Id = pId;
END ;;
DELIMITER ;

-- SP_ActualizarRolUsuario (NEW)
DROP PROCEDURE IF EXISTS `SP_ActualizarRolUsuario`;
DELIMITER ;;
CREATE PROCEDURE `SP_ActualizarRolUsuario`(
    pIdUsuario INT,
    pNuevoRol VARCHAR(20)
)
BEGIN
    UPDATE usuario 
    SET rol = pNuevoRol
    WHERE Id = pIdUsuario;
END ;;
DELIMITER ;

-- SP_ConsultarProductos
DROP PROCEDURE IF EXISTS `SP_ConsultarProductos`;
DELIMITER ;;
CREATE PROCEDURE `SP_ConsultarProductos`()
BEGIN
    SELECT Id, Nombre, Descripcion, Precio, Imagen, Disponibilidad FROM Productos;
END ;;
DELIMITER ;

-- SP_GuardarTokenActivacion
DROP PROCEDURE IF EXISTS `SP_GuardarTokenActivacion`;
DELIMITER ;;
CREATE PROCEDURE `SP_GuardarTokenActivacion`(
    IN p_idUsuario INT,
    IN p_token VARCHAR(64)
)
BEGIN
    UPDATE usuario 
    SET Activacion = p_token
    WHERE Id = p_idUsuario;
END ;;
DELIMITER ;

-- SP_IniciarSesion (updated with rol)
DROP PROCEDURE IF EXISTS `SP_IniciarSesion`;
DELIMITER ;;
CREATE PROCEDURE `SP_IniciarSesion`(
    pCorreo varchar(45),
    pContrasenna varchar(15)
)
BEGIN
    SELECT  U.Id,
            U.Nombre 'NombreUsuario',
            Correo,
            Contrasenna,
            IdPerfil,
            P.Nombre 'NombrePerfil',
            rol
    FROM    usuario U
    INNER JOIN perfil P ON U.IdPerfil = P.Id 
    WHERE   Correo = pCorreo
        AND Contrasenna = pContrasenna;
END ;;
DELIMITER ;

-- SP_RegistrarCuenta (updated with default role)
DROP PROCEDURE IF EXISTS `SP_RegistrarCuenta`;
DELIMITER ;;
CREATE PROCEDURE `SP_RegistrarCuenta`(
    pNombre varchar(250),
    pCorreo varchar(100),
    pContrasenna varchar(15),
    pActivacion varchar(64)
)
BEGIN
    INSERT INTO usuario(Nombre,Correo,Contrasenna,Activacion,IdPerfil,rol)
    VALUES(pNombre,pCorreo,pContrasenna,pActivacion,1,'cliente');
END ;;
DELIMITER ;

-- SP_ValidarToken
DROP PROCEDURE IF EXISTS `SP_ValidarToken`;
DELIMITER ;;
CREATE PROCEDURE `SP_ValidarToken`(
    IN pActivacion VARCHAR(64)
)
BEGIN
    SELECT Id, Nombre, Correo, IdPerfil, rol
    FROM usuario
    WHERE Activacion = pActivacion
    LIMIT 1;
END ;;
DELIMITER ;

-- SP_ValidarUsuarioCorreo (updated with rol)
DROP PROCEDURE IF EXISTS `SP_ValidarUsuarioCorreo`;
DELIMITER ;;
CREATE PROCEDURE `SP_ValidarUsuarioCorreo`(
    pCorreo varchar(100)
)
BEGIN
    SELECT  U.Id,
            U.Nombre 'NombreUsuario',
            Correo,
            Contrasenna,
            IdPerfil,
            P.Nombre 'NombrePerfil',
            rol
    FROM    usuario U
    INNER JOIN perfil P ON U.IdPerfil = P.Id 
    WHERE   Correo = pCorreo;
END ;;
DELIMITER ;

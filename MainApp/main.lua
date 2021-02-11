-----------------------------------------------------------------------------------------
-- MAIN LUA:Full Metal Corona
-- Progetto uniUd
-- Corso di game programming, Stm uniud.
--
-----------------------------------------------------------------------------------------
local composer = require 'composer'
-- Nasconde la barra di stato del telefono
display.setStatusBar( display.HiddenStatusBar )

-- Libreria composer
local composer = require "composer"

-- Inizio con caricamento del menù
composer.gotoScene( "scene.menu" )   --

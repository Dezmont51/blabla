@echo off
chcp 65001
echo.

path G:\Users\an.fokin\Desktop\OneScript-1.0.21\bin

set v8version=8.3.13.1644

set razrab_storage_name="tcp://app1-main/TB"
set prerelease_storage_name="tcp://app1-main/TB_prerelease"

set razrab_connection_string=/FE:\1C-dev\Fokin\Базы\ТБ
set prerelease_connection_string=/FE:\1C-dev\Fokin\Базы\ТБ_prerelise

set storage_user="Фокин"
rem Указать Пароль
set storage_pwd=%1 :Пароль
set db_user="Администратор"
rem Указать Пароль
set db_pwd=""

echo ┌───────────────────────────────────────────────────────┐
echo │ Обновляется из хранилища конфигурация ТБ (разработка) │
echo └───────────────────────────────────────────────────────┘
call vrunner loadrepo --storage-name %razrab_storage_name% --storage-user %storage_user% --storage-pwd %storage_pwd% ^
                      --ibconnection %razrab_connection_string% --db-user %db_user% --db-pwd %db_pwd%                ^
					  --v8version %v8version%
echo.

echo ┌──────────────────────────────────────────────────────┐
echo │ Обновляется из хранилища конфигурация ТБ (предрелиз) │
echo └──────────────────────────────────────────────────────┘
call vrunner loadrepo --storage-name %prerelease_storage_name% --storage-user %storage_user% --storage-pwd %storage_pwd% ^
                      --ibconnection %prerelease_connection_string% --db-user %db_user% --db-pwd %db_pwd%                ^
					  --v8version %v8version%
echo.

pause
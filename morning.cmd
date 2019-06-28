@echo off
chcp 65001
echo.

Echo Закрываем 1с!!!!
ping 127.0.0.1 -n 3 >nul

@taskkill /fi  "username eq %USERNAME%" /im 1cv8.exe>nul
Echo Ждем 10 секунд!!!
@taskkill /f /fi  "username eq %USERNAME%" /im 1cv8.exe>nul
@TIMEOUT /T 10 /NOBREAK 

path G:\Users\an.fokin\Desktop\OneScript-1.0.21\bin

set v8version=8.3.13.1644

set razrab_storage_name="tcp://app1-main/TB"
set prerelease_storage_name="tcp://app1-main/TB_prerelease"

set razrab_connection_string=/FE:\1C-dev\Fokin\Базы\ТБ
set prerelease_connection_string=/FE:\1C-dev\Fokin\Базы\ТБ_prerelise

set storage_user="Фокин"
rem Нужно указать Пароль
set storage_pwd="Пароль"
set db_user="Темт"
rem Нужно указать Пароль
set db_pwd="Пароль"

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
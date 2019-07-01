@echo off
chcp 65001
echo.

Echo Закрываем 1с!!!! rem Закрываем
ping 127.0.0.1 -n 3 >nul

@taskkill /fi  "username eq %USERNAME%" /im 1cv8.exe>nul
@taskkill /fi  "username eq %USERNAME%" /im 1cv8c.exe>nul
Echo Ждем 10 секунд!!!
@TIMEOUT /T 10 /NOBREAK 

@taskkill /f /fi  "username eq %USERNAME%" /im 1cv8.exe>nul
@taskkill /f /fi  "username eq %USERNAME%" /im 1cv8c.exe>nul
@TIMEOUT /T 10 /NOBREAK 

rem Изменяю переменную окружения, пути в ней
path G:\Users\an.fokin\Desktop\OneScript-1.0.21\bin

set v8version=8.3.13.1644

set razrab_storage_name="tcp://app1-main/TB"
set prerelease_storage_name="tcp://app1-main/TB_prerelease"

set razrab_connection_string=/FE:\1C-dev\Fokin\Базы\ТБ
set prerelease_connection_string=/FE:\1C-dev\Fokin\Базы\ТБ_prerelise

rem Ввод данных для авторизации. Либо прописть заранее, либо вводить по мере необходимости
::set storage_user="Фокин"
::set storage_pwd="1234" 
::set db_user="Темт"
rem Пароль
::set db_pwd="1234" 
rem Пароль
set /p storage_user=Введите пользователя хранилища:
set /p storage_pwd=Введите пароль хранилища:
set /p db_user=Введите пользователя базы:
rem Пароль
set /p db_pwd=Введите пароль базы:

echo ┌───────────────────────────────────────────────────────┐
echo │ Обновляется из хранилища конфигурация ТБ (разработка) │
echo └───────────────────────────────────────────────────────┘
call vrunner loadrepo --storage-name %razrab_storage_name% --storage-user %storage_user% --storage-pwd %storage_pwd% ^
                      --ibconnection %razrab_connection_string% --db-user %db_user% --db-pwd %db_pwd%                ^
					  --v8version %v8version%
echo.

echo ┌───────────────────────────────────────────────────────┐
echo │ Обновляется БД конфигурация ТБ (разработка)           │
echo └───────────────────────────────────────────────────────┘
call runner updatedb  --ibconnection %razrab_connection_string% --db-user %db_user% --db-pwd %db_pwd%                ^
					  --v8version %v8version%
echo.

echo ┌──────────────────────────────────────────────────────┐
echo │ Обновляется из хранилища конфигурация ТБ (предрелиз) │
echo └──────────────────────────────────────────────────────┘
call vrunner loadrepo --storage-name %prerelease_storage_name% --storage-user %storage_user% --storage-pwd %storage_pwd% ^
                      --ibconnection %prerelease_connection_string% --db-user %db_user% --db-pwd %db_pwd%                ^
					  --v8version %v8version%
echo.

echo ┌───────────────────────────────────────────────────────┐
echo │ Обновляется БД конфигурация ТБ (предрелиз)            │
echo └───────────────────────────────────────────────────────┘
call runner updatedb  --ibconnection %prerelease_connection_string% --db-user %db_user% --db-pwd %db_pwd%                ^
					  --v8version %v8version%
echo.

pause
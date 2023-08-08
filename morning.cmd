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
path C:\Users\an.fokin\Desktop\Automerge;C:\Program Files\OneScript\bin

set v8version=8.3.20.1613

set razrab_storage_name="tcp://repo1c/TB/dev"
set prerelease_storage_name="tcp://repo1c/TB/prerelease"

set path_razrab_connection_string="V:\1C-dev\Fokin\Base\TB"
set path_prerelease_connection_string="V:\1C-dev\Fokin\Base\TB_prerelise"
set razrab_connection_string=/F%path_razrab_connection_string%
set prerelease_connection_string=/F%path_prerelease_connection_string%

rem Ввод данных для авторизации. Либо прописть заранее, либо вводить по мере необходимости
set storage_user="Фокин"
set storage_pwd="123" 
set db_user="Темт"
rem Пароль
set db_pwd="1234" 
set current_date=%date:~6,4%-%date:~3,2%-01

goto start
set /p storage_user=Введите пользователя хранилища:
set /p storage_pwd=Введите пароль хранилища:
set /p db_user=Введите пользователя базы:
rem Пароль
set /p db_pwd=Введите пароль базы:
:start
echo ┌───────────────────────────────────────────────────────┐
echo │                    Обрезаем журналы                   │
echo └───────────────────────────────────────────────────────┘
call vrunner designer  --storage-name %razrab_storage_name% --storage-user %storage_user% --storage-pwd %storage_pwd% ^
                       --ibconnection %razrab_connection_string% --db-user %db_user% --db-pwd %db_pwd%                ^
                       --v8version %v8version% --additional "/ReduceEventLogSize %current_date%"
call vrunner designer  --storage-name %prerelease_storage_name% --storage-user %storage_user% --storage-pwd %storage_pwd% ^
                       --ibconnection %prerelease_connection_string% --db-user %db_user% --db-pwd %db_pwd%                ^
                       --v8version %v8version% --additional "/ReduceEventLogSize %current_date%"
rem start /wait 1cv8 DESIGNER %razrab_connection_string% /N%db_user% /P%db_pwd% /ReduceEventLogSize %current_date% 
rem start /wait 1cv8 DESIGNER %prerelease_connection_string% /N%db_user% /P%db_pwd% /ReduceEventLogSize %current_date% 
echo ┌───────────────────────────────────────────────────────┐
echo │                   Вакумируем журналы                  │
echo └───────────────────────────────────────────────────────┘
sqlite3 "%path_razrab_connection_string%\1Cv8Log\1Cv8.lgd" vacuum
sqlite3 "%path_prerelease_connection_string%\1Cv8Log\1Cv8.lgd" vacuum

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

echo ┌───────────────────────────────────────────────────────┐
echo │ Обновляется из хранилища конфигурация ТБ (предрелиз)  │
echo └───────────────────────────────────────────────────────┘
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

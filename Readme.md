# Формирование файла релиза из хранилища конфигурации

Скрипт [Onescript](oscript.io) для получения файла релиза и отчета по изменениям в конфигурации из хранилища конфигурации.
Одновременно создаются json-файлы: список авторов, таблица версий и json-версия отчета.

Настройки скрипта выполняются в json файле.

Скрипт запускается командой:

```cmd
cd \path-to-scrpt
oscript src\storage-report.os cfg\CONFIG-FILE-NAME.json [VERNUM]
```

В качестве обязательного параметра нужно указать путь до файла с настройками. 
Вторым необязательным параметром можно указать номер версии, с которого нужно формировать отчет. 
Параметр номера версии в командной строке имеет приоритет перед свойством `version` в файле настроек.

[Файл настроек](cfg\PRIMERvanessa-settings.json) унаследован от такового же из проекта [vanessa-runner](https://github.com/vanessa-opensource/vanessa-runner) и имеет следующую структуру:

```json
{
    "default": {
	"release": "0001",
        "ib": "myIB",
        "work-folder": "out",
        "--v8version": "8.3.18",
        "--uccode": "xxx90",
        "--storage-name": "tcp://storageserver/IB",
        "--storage-user": "admin",
        "--storage-pwd": "adminpassword",
        "--report-file": "./.build/myIB.mxl",
        "report-format": "json",
        "version": 1,
        "version-last": 1,
        "extension": "EXTENSION_NAME"
    }
}
```
в нем:
- release: номер собранного прошлый раз релиза. Строка. Инкрементируется при сборке. Если содерждит точку, инкрементируется минорная часть номера (Собирается исправительный релиз).
- ib: имя информационной базы в продуктовом кластере 1С:Предприятие
- work-folder: каталог, в котором создаются подкаталоги релизов в виде `ib\release`
- параметры с префиксом "--" - см. vanessa-runner
- report-format: формат дополнительного протокола. Не используется.
- version, version-last: начальный и конечный номер версий, по которым был сформирован отчет предыдущего релиза. 
- extension: если заполнен, формируется файл конфигурации указанного расширения.

> При сборке исправительного релиза, в формируемый отчет попадают версии, начиная с `version`, иначе, начиная с `version-last` по последнюю версию, прочитанную из хранилища

Скрипт `out\upd.cmd` обновляет конфигурацию тестовой ИБ переданной в качестве параметра.  
Использование: 

`out\upd.cmd ИМЯ_ТЕСТОВОЙ_ИБ [НОМЕР_ИЛИ_КАТАЛОГ_РЕЛИЗА]`

Например:
`out\upd.cmd mc_bnu_test 3`  

Конфигурация тестовой базы `mc_bnu_test` на сервере `obr-app-13` будет обновлена релизом из каталога out\bnu\0003. Если второй параметр опущен будет использован последний релиз.

> Формирование файлов релизов расширений библиотекой [v8runner](https://github.com/oscript-library/v8runner) реализовать пока не удалось, поэтому расширения выгружаются отдельным скриптом - `cmd/ext.cmd` 
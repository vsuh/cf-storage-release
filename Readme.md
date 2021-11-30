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

Файл настроек унаследован от такового же из проекта [vanessa-runner](https://github.com/vanessa-opensource/vanessa-runner) и имеет следующую структуру:

```json
{
    "default": {
	"release": 1,
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
        "extension": "EXTENSION_NAME"
    }
}
```

TODO: Если заполнен параметр `extension`, то формируется файл конфигурации указанного расширения.



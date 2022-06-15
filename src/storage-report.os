#use bsl-parser

#Использовать v8storage
#Использовать v8runner
#Использовать json
#Использовать fs
#Использовать logos

Перем Лог; // протокол
Перем ВсеНастройки; // соответствие из файла настроек
Перем ИмяФайлаНастроек; // Имя файла с настройками из параметра команды
Перем ЛатИмяКонфигурации; // Индекс ИБ: uat,bnu,zup
Перем АдресКаталогаВременнойИБ; // Каталог временной ИБ
Перем СтатусРелизаИсправительный; // Истина - исправительный релиз

Перем ПарсерJSON;
Перем НачВремя; // Время начала работы скрипта
Перем КаталогРабочихФайлов; // Каталог, в котором создаются файлы релиза
Перем ДоступныеФорматыОтчета; // Строка с разделителями допустимых форматов отчета (не исп)
Перем СтрокаВерсии; // Строка с новой версией конфигурации
Перем НомерНачальнойВерсии; // Номер версии, с которой начинается отчет по изменениям в конфигурации
Перем ИсправительныйРелиз; // Булево. Истина, если в номере релиза есть минорная часть

Функция Версия()
	Возврат "1.1.2";
КонецФункции

Функция ПолучитьСтрокуСимволов(_с, _ч)
	_ = "";
	Для нн = 1 По _ч Цикл
		_ = _ + _с;
	КонецЦикла;
	Возврат _;
КонецФункции

Процедура ОбрезатьТаблицуПоНачальномуНомеруВерсии(ТаблицаВерсий, НомерНачальнойВерсии)
	Лог.Отладка("Удаляю все версии меньше " + НомерНачальнойВерсии + " из таблицы версий");
	мсУдаляемыеСтроки = Новый Массив;
	Для Каждого _ Из ТаблицаВерсий Цикл
		Если _.Номер < НомерНачальнойВерсии Тогда
			мсУдаляемыеСтроки.Добавить(_);
		КонецЕсли;
	КонецЦикла;
	Для Каждого _ Из мсУдаляемыеСтроки Цикл
		ТаблицаВерсий.Удалить(_);
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьФорматированноеСообщение(Знач СобытиеЛога) Экспорт
	КартаСтатусовИУровней = Новый Соответствие;
	КартаСтатусовИУровней.Вставить(УровниЛога.Отладка, "ОТЛАДКА"); //  ОТЛАДКА
	КартаСтатусовИУровней.Вставить(УровниЛога.Информация, "   ИНФО"); //     ИНФО
	КартаСтатусовИУровней.Вставить(УровниЛога.Предупреждение, "ПРЕДУПР"); // ВНИМАНИЕ
	КартаСтатусовИУровней.Вставить(УровниЛога.Ошибка, " ОШИБКА"); //   ОШИБКА
	КартаСтатусовИУровней.Вставить(УровниЛога.КритичнаяОшибка, " КРИТИЧ"); // КРИТИЧНА
	
	Сообщение = СобытиеЛога.ПолучитьСообщение();
	УровеньСообщения = СобытиеЛога.ПолучитьУровень();
	УровеньЛога = СобытиеЛога.ПолучитьУровеньЛога();
	ДатаСобытия = СобытиеЛога.ПолучитьВремяСобытия();
	ДопПоля = СобытиеЛога.ПолучитьДополнительныеПоля();
	ИмяЛога = СобытиеЛога.ПолучитьИмяЛога();
	
	ФорматированноеСообщение = ""
		+ Формат(ТекущаяДата(), "ДФ=HH:mm:ss") + "\"
		+ Формат('00010101' + (ТекущаяДата() - НачВремя) + 1, "ДФ=HH:mm:ss") + " "
		+ КартаСтатусовИУровней[УровеньСообщения]
		+ " [" + ИмяЛога + "] " + Сообщение;
	// СформироватьФорматированныеСообщение(ДатаСобытия, УровеньСообщения,
	//                                                                 УровеньЛога, Сообщение,
	//                                                                 ДопПоля, ИмяЛога);
	Возврат ФорматированноеСообщение;
КонецФункции

Процедура Инициализировать()
	
	Если АргументыКоманднойСтроки.Количество() <> 2 Тогда
		Лог.Ошибка("Требуются 2 аргумента - файл настроек и признак испр. релиза");
		Возврат;
	Иначе
		ИмяФайлаНастроек = АргументыКоманднойСтроки[0];
		СтатусРелизаИсправительный = (Число(АргументыКоманднойСтроки[1]) = 1);
	КонецЕсли;
	
	Если НЕ ФС.Существует(ИмяФайлаНастроек) Тогда
		Лог.Ошибка("не найден файл настроек: " + ИмяФайлаНастроек);
		Возврат;
	КонецЕсли;
	ВсеНастройки = ПрочитатьФайлJSON(ИмяФайлаНастроек);
	Настройки = ВсеНастройки["default"];
	ЛатИмяКонфигурации = ПредставлениеИБ(Настройки["ib"]);
	
	// Попытка
	Лог = Логирование.ПолучитьЛог(ИмяПроекта() + "." + ПредставлениеИБ(Настройки["ib"]));
	ВыводПоУмолчанию = Новый ВыводЛогаВКонсоль();
	Лог.ДобавитьСпособВывода(ВыводПоУмолчанию, УровниЛога.Информация);
	
	// ФайлЖурнала = Новый ВыводЛогаВФайл;
	// ФайлЖурнала.ОткрытьФайл(ПутьФайлаВывода);
	// Лог.ДобавитьСпособВывода(ФайлЖурнала, УровниЛога.Отладка);
	// Лог.Отладка("Подключил вывод отладочного лога в отдельный файл %1", ПутьФайлаВывода);
	
	ВыводПротоколаВФайл = Новый ВыводЛогаВФайл;
	ВыводПротоколаВФайл.ОткрытьФайл(ОбъединитьПути("log", "storage-release." + ПредставлениеИБ(Настройки["ib"]) + ".log"));
	Лог.ДобавитьСпособВывода(ВыводПротоколаВФайл, УровниЛога.Отладка);
	// Исключение
	// Инфо = ИнформацияОбОшибке();
	// Лог.Отладка("Не смогли открыть лог в файле: " + ПодробноеПредставлениеОшибки(Инфо));
	// КонецПопытки;
	
	Лог.УстановитьУровень(УровниЛога.Отладка);
	Лог.УстановитьРаскладку(ЭтотОбъект);
	
	ДоступныеФорматыОтчета = СтрРазделить(НРег("mxl|json|xls"), "|");
	
	НачВремя = ТекущаяДата();
	
	ВывестиСтрокуЗаголовка();
КонецПроцедуры

Процедура ВывестиСтрокуЗаголовка()
	Наименование = "[ Формирование файлов релиза из хранилища конфигурации ]";
	Копирайт = " вер. " + Версия() + " | 2021@VSCraft";
	ДлинаСтроки = СтрДлина(Наименование);
	ДлинаКопирайта = СтрДлина(Копирайт);
	Попытка
		ШиринаКонсоли = Консоль.Ширина;
		Если ШиринаКонсоли < ДлинаСтроки - ДлинаКопирайта Тогда
			ВызватьИсключение "";
		КонецЕсли;
		ВтораяЧасть = Прав(ПолучитьСтрокуСимволов(" ", 300) + Копирайт, ШиринаКонсоли - ДлинаСтроки - 1);
	Исключение
		ШиринаКонсоли = 80;
		ВтораяЧасть = " " + Копирайт;
	КонецПопытки;
	Сообщить(Наименование + ВтораяЧасть);
	Лог.Информация(ПолучитьСтрокуСимволов("`", ШиринаКонсоли - 48));
КонецПроцедуры

Функция КаталогПроекта()
	ФайлИсточника = Новый Файл(СтартовыйСценарий().Источник);
	Лог.Отладка("Определил каталог проекта как " + ФайлИсточника.Путь);
	Возврат ФайлИсточника.Путь;
КонецФункции

Функция ИмяПроекта()
	// ФайлИсточника = Новый Файл(СтартовыйСценарий().Источник);
	Возврат "storage.CF";
КонецФункции

Процедура ЗаписатьИзмененияВНастройки(НомерВерсии, НомерКонВерсии, НомерРелиза)
	Лог.Отладка("Записываю измененные параметры в файл настроек");
	ВсеНастройки["default"].Вставить("version", НомерВерсии);
	ВсеНастройки["default"].Вставить("version-last", НомерКонВерсии);
	ВсеНастройки["default"].Вставить("release", НомерРелиза);
	СтрокаДляЗаписи = ПарсерJSON.ЗаписатьJSON(ВсеНастройки);
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайлаНастроек);
	ЗаписьТекста.ЗаписатьСтроку(СтрокаДляЗаписи);
	ЗаписьТекста.Закрыть();
КонецПроцедуры

Функция ПрочитатьФайл(Знач ИмяФайла, Знач Кодировка = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Кодировка) Тогда
		Кодировка = КодировкаТекста.UTF8;
	КонецЕсли;
	
	Чтение = Новый ЧтениеТекста(ИмяФайла, Кодировка, , , Ложь);
	Результат = Чтение.Прочитать();
	Чтение.Закрыть();
	
	Возврат Результат;
КонецФункции

Функция ПрочитатьФайлJSON(Знач ИмяФайла) Экспорт
	
	ФайлСуществующий = Новый Файл(ИмяФайла);
	Если НЕ ФайлСуществующий.Существует() Тогда
		Возврат Новый Соответствие;
	КонецЕсли;
	JsonСтрока = ПрочитатьФайл(ИмяФайла);
	
	ПарсерJSON = Новый ПарсерJSON();
	Результат = ПарсерJSON.ПрочитатьJSON(JsonСтрока);
	
	Возврат Результат;
КонецФункции

Функция ЗаписатьФайлJSON(ИмяФайла, Значение)
	
	Лог.Отладка("Записываю объект настроек в json файл " + ИмяФайла);
	
	ФайлСуществующий = Новый Файл(ИмяФайла);
	
	ПарсерJSON = Новый ПарсерJSON();
	JsonСтрока = ПарсерJSON.ЗаписатьJSON(Значение);
	Запись = Новый ЗаписьТекста(ИмяФайла);
	Запись.Записать(JsonСтрока);
	Запись.Закрыть();
	Возврат Истина;
КонецФункции

Процедура ПреобразоватьФайлОтчета(УправлениеКонфигуратором, ИмяФайлаОтчета, ИмяФайлаНовогоОтчета, ФорматФайлаОтчета)
	Лог.Отладка("Преобразую " + ИмяФайлаОтчета + " в " + ИмяФайлаНовогоОтчета + " в формате """ + ФорматФайлаОтчета + """");
	
	Если ДоступныеФорматыОтчета.Найти(НРег(ФорматФайлаОтчета)) = Неопределено Тогда
		Лог.Ошибка("!!! Неподдерживаемый формат отчета: " + ФорматФайлаОтчета);
		Возврат;
	Иначе
		ФорматФайлаОтчета = НРег(ФорматФайлаОтчета);
	КонецЕсли;
	
	Если ФорматФайлаОтчета = "json" Тогда
		КлючЗапуска = СтрШаблон("""%1;%2""", ИмяФайлаОтчета, ИмяФайлаНовогоОтчета);
		ПараметрыЗапускаОбработки = СтрШаблон("/Execute ""%1""", "src\ОбработкаКонвертацииMXLJSON.epf");
		УправлениеКонфигуратором.ЗапуститьВРежимеПредприятия(КлючЗапуска, Ложь, ПараметрыЗапускаОбработки);
	ИначеЕсли ФорматФайлаОтчета = "xls" Тогда
		Лог.Информация("!!! Формат отчета: """ + ФорматФайлаОтчета + """ еще не реализован");
	ИначеЕсли ФорматФайлаОтчета = "mxl" Тогда
		Возврат;
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Функция ВсеНужныеНастройкиУказаны(Настройки)
	Лог.Отладка("Проверяю все ли настройки присутствуют в файле настроек");
	
	ИспользуемыеНастройки = СтрРазделить(
			"release,ib,work-folder,--v8version,--storage-name"
			+ ",--storage-user,--storage-pwd"
			+ ",report-format,version,version-last,extension"
			, ",");
	
	Если ТипЗнч(Настройки) = Тип("Соответствие") Тогда
		Для Каждого ИмяНастройки Из ИспользуемыеНастройки Цикл
			Если Настройки.Получить(ИмяНастройки) = Неопределено Тогда
				Лог.Ошибка("!!! В файле " + ИмяФайлаНастроек + " отсутствует настройка """ + ИмяНастройки + """");
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(Настройки) = Тип("Структура") Тогда
		Для Каждого ИмяНастройки Из ИспользуемыеНастройки Цикл
			Если НЕ Настройки.Свойство(ИмяНастройки) Тогда
				Лог.Ошибка("!!! В файле " + ИмяФайлаНастроек + " отсутствует настройка """ + ИмяНастройки + """");
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Лог.Ошибка("!!! Неизвестный тип настроек: """ + ТипЗнч(Настройки) + """ из файла " + ИмяФайлаНастроек + "");
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Функция ПредставлениеНомераРелиза(
		МажорнаяЧасть
		, МинорнаяЧасть = 0
		, ДлинаМажорнойЧасти = 4
		, ДлинаМинорнойЧасти = 2
	)
	Если МинорнаяЧасть = 0 Тогда
		Возврат Прав("000000" + Строка(МажорнаяЧасть), ДлинаМажорнойЧасти);
	Иначе
		Возврат ПредставлениеНомераРелиза(МажорнаяЧасть) + "." + Прав("000000" + Строка(МинорнаяЧасть), ДлинаМинорнойЧасти);;
	КонецЕсли;
КонецФункции

Функция ПредставлениеИБ(ИБ)
	Возврат СтрЗаменить(ИБ, "mc_", "");
КонецФункции

Функция ПолучитьСтрокуСледующегоРелиза(СтрокаТекущегоРелиза)
	Лог.Отладка("Определяю строку следующего релиза для """ + СтрокаТекущегоРелиза + """");
	МассивЧастей = СтрРазделить(СтрокаТекущегоРелиза, ".");
	Лог.Отладка("Разделил строку текущей версии на " + МассивЧастей.Количество() + " частей");
	
	Если МассивЧастей.Количество() = 1 Тогда // строка состоит только из мажорной части
		ИсправительныйРелиз = Ложь;
		НомерСледующегоРелиза = Число(СтрокаТекущегоРелиза) + 1;
		Возврат ПредставлениеНомераРелиза(НомерСледующегоРелиза);
	Иначе
		ИсправительныйРелиз = Истина;
		МажорнаяЧастьНомера = Число(МассивЧастей[0]);
		МинорнаяЧастьНомера = ?(ПустаяСтрока(МассивЧастей[1]), 1, 1 + Число(МассивЧастей[1]));
		Лог.Отладка("Определил части номера следующего релиза мажор: " + МажорнаяЧастьНомера + " минор: " + МинорнаяЧастьНомера + "");
		Возврат ПредставлениеНомераРелиза(МажорнаяЧастьНомера, МинорнаяЧастьНомера);
	КонецЕсли;
	Лог.Ошибка("Не удалось изменить строку релиза, возвращаю текущую """ + СтрокаТекущегоРелиза + """");
	Возврат СтрокаТекущегоРелиза;
КонецФункции
// ********************************************* Изменение версии в синониме *************************** //
Функция СоздатьФайлСпискаВыгружаемыхОбъектов()
	ИмяФайла = "listFiles." + ЛатИмяКонфигурации + ".lst";
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла);
	ЗаписьТекста.ЗаписатьСтроку("Configuration");
	ЗаписьТекста.Закрыть();
	Возврат ИмяФайла;
КонецФункции

Процедура ВыгрузитьКонфигурациюВФайлы(УправлениеКонфигуратором, КаталогИсходников)
	ФС.ОбеспечитьПустойКаталог(КаталогИсходников);
	ПараметрыЗапуска = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/DumpConfigToFiles " + КаталогИсходников);
	ПараметрыЗапуска.Добавить("-listFile " + СоздатьФайлСпискаВыгружаемыхОбъектов());
	// ПараметрыЗапуска.Добавить("/out log\unload-to-files." + ЛатИмяКонфигурации + ".log");
	
	Попытка
		Лог.Информация("Выгрузка корня конфигурации """ + ЛатИмяКонфигурации + """ в каталог """ + КаталогИсходников + """");
		УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
		УправлениеКонфигуратором.ВыполнитьКоманду(ПараметрыЗапуска);
		ФайлКонфигурации = ПроверитьКаталогВыгрузки(КаталогИсходников);
		ОбработатьФайлКонфигурации(ФайлКонфигурации);
	Исключение
		Лог.Ошибка(УправлениеКонфигуратором.ВыводКоманды());
	КонецПопытки;
КонецПроцедуры

Функция ПроверитьКаталогВыгрузки(КаталогИсходников)
	Лог.Отладка("Проверяю существование выгруженного файла Configuration.xml");
	ФайлКонфигурации = Новый Файл(ОбъединитьПути(КаталогИсходников, "Configuration.xml"));
	Если НЕ ФайлКонфигурации.Существует() Тогда
		ВызватьИсключение "Отсутствует файл " + ФайлКонфигурации.ПолноеИмя;
	КонецЕсли;
	Возврат ФайлКонфигурации;
КонецФункции

Функция ВычислитьСтрокуНовогоСинонима(НачСиноним)
	ОжидаемоеКолВоГрупп = 5;
	Если ТипЗнч(НачСиноним) = Тип("Структура") И НачСиноним.Свойство("ru") Тогда
		НачальноеЗначениеСинонима = НачСиноним["ru"];
	ИначеЕсли ТипЗнч(НачСиноним) = Тип("Строка") Тогда
		НачальноеЗначениеСинонима = НачСиноним;
	Иначе
		ВызватьИсключение "Неизвестный тип синонима: " + НачСиноним;
	КонецЕсли;
	Лог.Отладка("Текущий синоним: """ + НачальноеЗначениеСинонима + """");
	
	РегулярноеВыражение = Новый РегулярноеВыражение("(.*)\[(\d{1,4})\.?(\d\d)?\s+от\s+(\d{1,2}\.\d{1,2}\.\d{2,4})\]");
	Если НЕ РегулярноеВыражение.Совпадает(НачальноеЗначениеСинонима) Тогда
		Синоним = СокрЛП(ИмяКонфигурацииПоТегу(ЛатИмяКонфигурации)) + " [0001 от " + Формат(ТекущаяДата(), "ДФ='dd.MM.yyyy'") + "]";
	Иначе
		Совпадения = РегулярноеВыражение.НайтиСовпадения(НачальноеЗначениеСинонима);
		ВсеГруппы = Совпадения[0].Группы;
		Если ВсеГруппы.Количество() <> ОжидаемоеКолВоГрупп Тогда
			Синоним = СокрЛП(ИмяКонфигурацииПоТегу(ЛатИмяКонфигурации)) + " [0001 от " + Формат(ТекущаяДата(), "ДФ='dd.MM.yyyy'") + "]";
		КонецЕсли;
		ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
		
		ПерваяГруппа = ВсеГруппы[1].Значение;
		ВтораяГруппа = ВсеГруппы[2].Значение;
		ТретьяГруппа = ВсеГруппы[3].Значение;
		Лог.Отладка("Получены группы: №1 """ + ПерваяГруппа + """ №2 """ + ВтораяГруппа + """ №3 """ + ТретьяГруппа + """");
		Мажор = ОписаниеТипаЧисло.ПривестиЗначение(ВтораяГруппа);
		Если НЕ ПустаяСтрока(ТретьяГруппа) Тогда
			Минор = ОписаниеТипаЧисло.ПривестиЗначение(ТретьяГруппа);
		Иначе
			Минор = 0;
		КонецЕсли;
		
		Если СтатусРелизаИсправительный Тогда
			НомерРелиза = Прав("0000" + Строка(Мажор), 4) + "." + Прав("00" + (1 + Минор), 2);
		Иначе
			НомерРелиза = Прав("0000" + Строка(1 + Мажор), 4);
		КонецЕсли;
		Синоним = СокрЛП(ПерваяГруппа) + " [" + НомерРелиза + " от " + Формат(ТекущаяДата(), "ДФ='dd.MM.yyyy'") + "]";
	КонецЕсли;
	Лог.Отладка("Следующий синоним: """ + Синоним + """");
	СтрокаВерсии = Синоним;
	Если ТипЗнч(НачСиноним) = Тип("Структура") И НачСиноним.Свойство("ru") Тогда
		Возврат Новый Структура("ru", Синоним);
	Иначе
		Возврат Синоним;
	КонецЕсли;
КонецФункции

Процедура ОбработатьФайлКонфигурации(ФайлКорняКонфигурации)
	Перем ПустойСиноним;
	
	Парсер = РазборКонфигураций.ЗагрузитьКонфигурацию(ФайлКорняКонфигурации.Путь);
	Конфигурация = Парсер.ОписаниеКонфигурации();
	Если ТипЗнч(Конфигурация.СвойстваКонфигурации.Синоним) = Тип("Структура")
		И Конфигурация.СвойстваКонфигурации.Синоним.Свойство("ru")
		Тогда
		ОригТекстСинонима = Конфигурация.СвойстваКонфигурации.Синоним.ru;
	Иначе
		ОригТекстСинонима = Конфигурация.СвойстваКонфигурации.Синоним;
	КонецЕсли;
	ПустойСиноним = ПустаяСтрока(ОригТекстСинонима);
	
	Лог.Отладка("Прочитали существующий синоним - """ + ОригТекстСинонима + """");
	НовыйТекстСинонима = ВычислитьСтрокуНовогоСинонима(ОригТекстСинонима);
	Лог.Отладка("Вычислили новый синоним - """ + ОригТекстСинонима + """");
	Текст = Новый ТекстовыйДокумент;
	Текст.Прочитать(ФайлКорняКонфигурации.ПолноеИмя, "UTF-8");
	СтрокаXML = Текст.ПолучитьТекст();
	Если ПустойСиноним Тогда
		СтрокаXML = СтрЗаменить(СтрокаXML, "<Synonym/>", "<Synonym>" + НовыйТекстСинонима + "</Synonym>");
	Иначе
		СтрокаXML = СтрЗаменить(СтрокаXML, ОригТекстСинонима, НовыйТекстСинонима);
	КонецЕсли;
	Текст.УстановитьТекст(СтрокаXML);
	Текст.Записать(ФайлКорняКонфигурации.ПолноеИмя, "UTF-8");
КонецПроцедуры

Функция ИмяКонфигурацииПоТегу(Тег)
	Если НРег(Тег) = "uat" Тогда
		Имя = "Управление автотранспортом Стандарт, редакция 1.0";
	ИначеЕсли НРег(Тег) = "zup" Тогда
		Имя = "Зарплата и управление персоналом КОРП, редакция 3.1";
	ИначеЕсли НРег(Тег) = "bnu" ИЛИ НРег(Тег) = "upp" Тогда
		Имя = "Управление производственным предприятием, редакция 1.3";
	Иначе
		Имя = "Конфигурация 1C";
	КонецЕсли;
	Возврат Имя;
КонецФункции

Процедура ЗагрузитьКонфигурациюИзФайлов(УправлениеКонфигуратором, КаталогИсходников)
	// УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайлов(
	// 	КаталогИсходников,
	// 	СоздатьФайлСпискаВыгружаемыхОбъектов(), , , Истина);
	ПараметрыЗапуска = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/LoadConfigFromFiles " + КаталогИсходников);
	ПараметрыЗапуска.Добавить(" -files Configuration.xml");
	//	ПараметрыЗапуска.Добавить("/out log\Load-to-files." + ЛатИмяКонфигурации + ".log");
	
	Попытка
		Лог.Информация("Загрузка конфигурации """ + ЛатИмяКонфигурации + """ из каталог " + КаталогИсходников);
		УправлениеКонфигуратором.ВыполнитьКоманду(ПараметрыЗапуска);
	Исключение
		Лог.Ошибка(УправлениеКонфигуратором.ВыводКоманды());
	КонецПопытки;
КонецПроцедуры

Процедура ПрименитьИзмененияВКонфигурации(УправлениеКонфигуратором, Настройки)
	Лог.Информация("Помещаю изменения версии в хранилище");
	УправлениеКонфигуратором.ПоместитьИзмененияОбъектовВХранилище(
		Настройки["--storage-name"], Настройки["--storage-user"], Настройки["--storage-pwd"], ,
		"вер. " + СтрокаВерсии);
	
	// Параметры = УправлениеКонфигуратором.СтандартныеПараметрыЗапускаКонфигуратора();
	
	// Параметры.Добавить("/ConfigurationRepositoryF """ + Настройки["--storage-name"] + """");
	// Параметры.Добавить("/ConfigurationRepositoryN """ + Настройки["--storage-user"] + """");
	// Параметры.Добавить("/ConfigurationRepositoryP """ + Настройки["--storage-pwd"] + """");
	// Параметры.Добавить("/ConfigurationRepositoryCommit ");
	
	// // Если Не ПустаяСтрока(СписокОбъектов) Тогда
	// //     Параметры.Добавить(СтрШаблон("-objects ""%1""", СписокОбъектов));
	// // КонецЕсли;
	
	// Параметры.Добавить("-comment ""%1""", "вер. " + СтрокаВерсии);
	// УправлениеКонфигуратором.ВыполнитьКоманду(Параметры);
	
КонецПроцедуры

Процедура ПоместитьИзменения(УправлениеКонфигуратором)
КонецПроцедуры
//<<-- ***************************************** Изменение версии в синониме *************************** //
Процедура ВыполнитьВсеДействия()
	Настройки = ВсеНастройки["default"];
	СтрокаТекущегоРелиза = ПолучитьСтрокуСледующегоРелиза(Настройки["release"]);
	Если НЕ ВсеНужныеНастройкиУказаны(Настройки) Тогда
		Возврат;
	КонецЕсли;
	РежимРасширение = ЗначениеЗаполнено(Настройки["extension"]);
	ИмяИБ = ПредставлениеИБ(Настройки["ib"]);
	
	РабочийКаталог = Настройки["work-folder"];
	
	КаталогРабочихФайлов = ОбъединитьПути(РабочийКаталог, ИмяИБ, СтрокаТекущегоРелиза);
	ФС.ОбеспечитьКаталог(КаталогРабочихФайлов);
	
	АдресКаталогаВременнойИБ = "v8_tmp_" + ИмяИб;
	НомерКонВерсии = 9999;
	Лог.Отладка("Получаю настройки конфигуратора с вер." + Настройки["--v8version"]);
	УправлениеКонфигуратором = Новый УправлениеКонфигуратором();
	УправлениеКонфигуратором.ИспользоватьВерсиюПлатформы(Настройки["--v8version"]);
	УправлениеКонфигуратором.СоздатьФайловуюБазу(АдресКаталогаВременнойИБ);
	
	Лог.Информация("Каталог временной базы: """ + АдресКаталогаВременнойИБ + """");
	УправлениеКонфигуратором.УстановитьКонтекст("/F" + АдресКаталогаВременнойИБ, "", "");
	
	Лог.Информация("Подключаю временную ИБ к хранилищу конфигурации """ + ИмяИБ + """");
	Лог.Отладка("Соединяюсь с хранилищем конфигурации " + Настройки["--storage-name"]);
	ХранилищеКонфигурации = Новый МенеджерХранилищаКонфигурации( , УправлениеКонфигуратором);
	ХранилищеКонфигурации.УстановитьПутьКХранилищу(Настройки["--storage-name"]);
	ХранилищеКонфигурации.УстановитьПараметрыАвторизации(Настройки["--storage-user"], Настройки["--storage-pwd"]);
	ХранилищеКонфигурации.ПодключитьсяКХранилищу(Истина);
	ХранилищеКонфигурации.ПрочитатьХранилище();
	
	// Лог.Информация("Захватываю корень в хранилище");
	// ХранилищеКонфигурации.ЗахватитьОбъектыВХранилище("cfg\root.xml");
	// Лог.Информация("Захват прошел успешно");
	
	// изменение номера релиза
	// (:: захватить корень конфигурации нерекурсивно)
	// КаталогИсходников = ".src." + ЛатИмяКонфигурации;
	// Лог.Информация("Выгружаю конфигурацию в файлв в """ + КаталогИсходников + """");
	// ВыгрузитьКонфигурациюВФайлы(УправлениеКонфигуратором, КаталогИсходников);
	// Лог.Информация("Загружаю исправленные файлы в конфигурацию из """ + КаталогИсходников + """");
	// ЗагрузитьКонфигурациюИзФайлов(УправлениеКонфигуратором, КаталогИсходников);
	// Лог.Информация("Применяю изменения в конфигурации");
	// ПрименитьИзмененияВКонфигурации(УправлениеКонфигуратором, Настройки);
	// Лог.Информация("Помещаю измененный корень конфигурации в хранилище");
	// ПоместитьИзменения(УправлениеКонфигуратором);
	//  Лог.Информация("Удаляю временные каталоги");
	//  УдалитьФайлы(КаталогИсходников);
	// Raise "*** Временный Конец ***";
	// (:: поместить измененный корень в хранилище)
	// << ***
	// Лог.Информация("Помещаю измененный синоним в хранилище: """ + СтрокаВерсии + """");
	// ХранилищеКонфигурации.ПоместитьИзмененияОбъектовВХранилище("cfg\root.xml", "изменен синоним " + СтрокаВерсии);
	
	Лог.Информация("Получаю таблицы авторов и версий");
	Лог.Отладка("Получаю таблицу версий ");
	ТаблицаВерсий = ХранилищеКонфигурации.ПолучитьТаблицуВерсий();
	Попытка
		НомерНачВерсииИзКонфФайла = Настройки["version"];
	Исключение
		НомерНачВерсииИзКонфФайла = 1;
	КонецПопытки;
	Попытка
		НомКонВерсииИзКонфФайла = Настройки["version-last"];
	Исключение
		НомКонВерсииИзКонфФайла = 1;
	КонецПопытки;
	
	Если НомерНачВерсииИзКонфФайла > 1 Тогда
		Лог.Информация("Таблица версий обрезается с № " + НомерНачВерсииИзКонфФайла);
		ОбрезатьТаблицуПоНачальномуНомеруВерсии(ТаблицаВерсий, НомерНачВерсииИзКонфФайла);
	КонецЕсли;
	Лог.Отладка("Получаю массив авторов ");
	МассивАвторов = ХранилищеКонфигурации.ПолучитьАвторов();
	
	Если ТаблицаВерсий.Количество() = 0 Тогда
		НомПоследнейВерсииВХранилище = НомКонВерсииИзКонфФайла;
	Иначе
		НомПоследнейВерсииВХранилище = ТаблицаВерсий[ТаблицаВерсий.Количество() - 1].Номер;
	КонецЕсли;
	
	ПостфиксИмениФайла = ИмяИБ + "_" + СтрокаТекущегоРелиза + "_" + Формат(ТекущаяДата(), "ДФ=yyyy-MM-dd");
	СтрокаДиапазонаВерсий = "_[" + НомерНачВерсииИзКонфФайла + "-" + НомПоследнейВерсииВХранилище + "]";
	
	ИмяФайлаАвторов = ОбъединитьПути(КаталогРабочихФайлов, ПостфиксИмениФайла
			+ СтрокаДиапазонаВерсий + ".AUTHORS" + ".json");
	ИмяФайлаВерсий = ОбъединитьПути(КаталогРабочихФайлов, ПостфиксИмениФайла + СтрокаДиапазонаВерсий + ".VERS" + ".json");
	ИмяФайлаРелиза = ОбъединитьПути(КаталогРабочихФайлов, ПостфиксИмениФайла + ?(РежимРасширение, ".cfe", ".cf"));
	ИмяФайлаОтчета = ОбъединитьПути(КаталогРабочихФайлов, ПостфиксИмениФайла + ?(РежимРасширение, "_ext", "")
			+ "" + СтрокаДиапазонаВерсий + ".REPORT" + ".mxl");
	
	ЗаписатьФайлJSON(ИмяФайлаАвторов, МассивАвторов);
	ЗаписатьФайлJSON(ИмяФайлаВерсий, ТаблицаВерсий);
	Лог.Информация("Выгружаю CF-файл релиза из хранилища в файл " + ИмяФайлаРелиза);
	// If РежимРасширение Then
	// 	ХранилищеКонфигурации.УстановитьРасширениеХранилища("грРасширениеЗУП");
	// EndIf;
	ХранилищеКонфигурации.СохранитьВерсиюКонфигурацииВФайл( , ИмяФайлаРелиза);
	// If РежимРасширение Then
	// 	Лог.Информация("Формирую отчет по версиям. с " + НомерНачВерсииИзКонфФайла + " по "
	// 		+ НомПоследнейВерсииВХранилище + " в " + ИмяФайлаОтчета);
	// 	ХранилищеКонфигурации.ПолучитьОтчетПоВерсиям(ИмяФайлаОтчета
	// 		, НомерНачВерсииИзКонфФайла, НомПоследнейВерсииВХранилище);
	// Else
	Лог.Информация("Формирую отчет по версиям. с " + НомерНачВерсииИзКонфФайла + " по "
		+ НомПоследнейВерсииВХранилище + " в " + ИмяФайлаОтчета);
	ХранилищеКонфигурации.ПолучитьОтчетПоВерсиям(ИмяФайлаОтчета
		, НомерНачВерсииИзКонфФайла, НомПоследнейВерсииВХранилище);
	// EndIf;
	
	Если НомерНачВерсииИзКонфФайла = НомПоследнейВерсииВХранилище Тогда
		Лог.Предупреждение("В релиз не вошли никакие изменения");
	КонецЕсли;
	
	Лог.Отладка("Переформатирую отчет в `json`");
	ФайлНовогоОтчета = Новый Файл(ИмяФайлаОтчета);
	ИмяФайлаНовогоОтчета = ОбъединитьПути(КаталогРабочихФайлов, ФайлНовогоОтчета.ИмяБезРасширения + ".json");
	
	// If NOT ПустаяСтрока(Настройки["report-format"]) Then
	ПреобразоватьФайлОтчета(УправлениеКонфигуратором, ИмяФайлаОтчета, ИмяФайлаНовогоОтчета, Настройки["report-format"]);
	// EndIf;
	Если СтатусРелизаИсправительный Тогда
		// If ИсправительныйРелиз Then // В каждый отчет по испр. релизу включать все изменения с начала исправлений
		НомерНачВер = НомерНачВерсииИзКонфФайла;
	Иначе
		НомерНачВер = НомКонВерсииИзКонфФайла;
	КонецЕсли;
	НомерКонВер = НомПоследнейВерсииВХранилище;
	
	ЗаписатьИзмененияВНастройки(НомерНачВер, НомерКонВер, СтрокаТекущегоРелиза);
	Лог.Отладка("Удаляю временные файлы из " + АдресКаталогаВременнойИБ);
	УдалитьФайлы(АдресКаталогаВременнойИБ);
	Лог.Информация("Завершено");
	Лог.Закрыть();
КонецПроцедуры

// ************************************************************** //
ИсправительныйРелиз = Ложь;
Инициализировать();
ВыполнитьВсеДействия();
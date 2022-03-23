﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	 УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормой()
	СертификатЗаполнен = Не Объект.Сертификат.Пустая();
	Элементы.Сертификат.Видимость = СертификатЗаполнен;
	Элементы.ГруппаПериодДействияСертификата.Видимость = СертификатЗаполнен;
	Элементы.НадписьСертификатОтсутствует.Видимость = Не СертификатЗаполнен;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СрокОсвобожденияОтПрививкиПриИзмененииНаСервере(СтруктураПараметров)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сотрудник", СтруктураПараметров.Сотрудник);
	Запрос.УстановитьПараметр("ДатаОсвобожденияОтПрививки", СтруктураПараметров.ДатаОсвобождения);
	Запрос.Текст = "ВЫБРАТЬ
	|	докСертификат.Ссылка КАК Сертификат
	|ИЗ
	|	Документ.COV_СертификатОВакцинацииОтCOVID КАК докСертификат
	|ГДЕ
	|	докСертификат.Сотрудник = &Сотрудник
	|	И НЕ докСертификат.ПометкаУдаления
	|	И докСертификат.СертификатДействителен
	|	И докСертификат.КонецДействияСертификата <= &ДатаОсвобожденияОтПрививки";
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Количество() = 0 Тогда 
		Возврат Неопределено;
	Иначе 
		Результат.Следующий();
		Возврат Результат.Сертификат;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура СрокОсвобожденияОтПрививкиПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.СрокОсвобожденияОтПрививки) Тогда 
		ПараметрыПоиска = Новый Структура("Сотрудник, ДатаОсвобождения", Объект.Сотрудник, Объект.СрокОсвобожденияОтПрививки);
		Объект.Сертификат = СрокОсвобожденияОтПрививкиПриИзмененииНаСервере(ПараметрыПоиска);
		Если ЗначениеЗаполнено(Объект.Сертификат) Тогда 
			Объект.НачалоДействияСертификата = Объект.Сертификат.НачалоДействияСертификата;
			Объект.КонецДействияСертификата =  Объект.Сертификат.КонецДействияСертификата;
		КонецЕсли;
	Иначе 
		Объект.Сертификат = Неопределено;
	КонецЕсли;
	УправлениеФормой();
КонецПроцедуры



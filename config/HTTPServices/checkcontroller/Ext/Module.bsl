﻿Функция ПолучитьДанныеПоПроверяющему(Запрос)
	тОтвет = "Ок";
	
	КодПроверяющего = Запрос.ПараметрыURL.Получить("controller_code");
	КодАптеки = Запрос.ПараметрыURL.Получить("apt_code");
	
	Попытка 
		КодАптекиЧисло = Число(КодАптеки);
	Исключение
		КодАптекиЧисло = -1;
	КонецПопытки;
	
	Если КодАптекиЧисло = -1 Тогда
		тОшибка = "Неверный код аптеки";
		тОтвет = ?(тОтвет = "Ок", тОшибка, тОтвет+"; "+тОшибка);
	ИначеЕсли КодАптекиЧисло > 0 Тогда
		НайденаяАптека = Справочники.МестаХранения.НайтиПоКоду(КодАптекиЧисло);
	КонецЕсли;
	
	Если тОтвет = "Ок" и КодАптекиЧисло > 0 И НайденаяАптека = Справочники.МестаХранения.ПустаяСсылка() Тогда
		тОшибка = "Не найдена аптека по коду: "+КодАптекиЧисло;
		тОтвет = ?(тОтвет = "Ок", тОшибка, тОтвет+"; "+тОшибка);
	КонецЕсли;	
	
	СпрПроверяющие = Справочники.ПроверяющиеОтПоставщика;
	НайденыйПроверяющий = СпрПроверяющие.НайтиПоРеквизиту("КодПроверяющего",КодПроверяющего);

	Если (НайденыйПроверяющий = СпрПроверяющие.ПустаяСсылка())
			Или НайденыйПроверяющий.ПометкаУдаления	Тогда
		тОшибка = "Не найден проверяющий по коду: "+КодПроверяющего;
		тОтвет = ?(тОтвет = "Ок", тОшибка, тОтвет+"; "+тОшибка);
	КонецЕсли;
	
	резДоступ = 1;
	
	Если (тОтвет = "Ок") и (КодАптекиЧисло > 0) Тогда
		Запрос = Новый Запрос;
		
		Запрос.Текст = "ВЫБРАТЬ
		|	КонтрактыИАптеки.Ссылка
		|ИЗ
		|	Справочник.КонтрактыИАптеки КАК КонтрактыИАптеки 
		|ГДЕ
		|	КонтрактыИАптеки.Аптека.Код = &АптекаКод
		|		И КонтрактыИАптеки.Владелец.Владелец.Ссылка = &Поставщик
		|		И КонтрактыИАптеки.Активность = ИСТИНА И КонтрактыИАптеки.Владелец.Активность = ИСТИНА
		|";

		Запрос.УстановитьПараметр("Поставщик",НайденыйПроверяющий.Владелец);
		Запрос.УстановитьПараметр("АптекаКод",КодАптекиЧисло);
		Рез = Запрос.Выполнить();
		Если Рез.Пустой() Тогда
			резДоступ = 0;
		КонецЕсли;
	КонецЕсли;	
	
	ЗаписьJSON	= Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	МассивМатрица = Новый Массив;
	МассивМатрица.Добавить(Новый Структура("ФИОПроверяющего,Поставщик,Доступ,ИнструкцияПроверяющего",
		СокрЛП(НайденыйПроверяющий.Наименование),
		СокрЛП(НайденыйПроверяющий.Владелец.Наименование),
		Строка(резДоступ),
		СокрЛП(НайденыйПроверяющий.Владелец.ИнструкцияПроверяющего)));
	
	Попытка
		ЗаписатьJSON(ЗаписьJSON, МассивМатрица);
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();
	Исключение
		тОтвет = "Ошибка: "+ОписаниеОшибки();
	КонецПопытки;

	Ответ = Новый HTTPСервисОтвет(200);
	
	ТекстОтвета = "{""error"":"""+СокрЛП(тОтвет)+"""}";
	
	Если тОтвет = "Ок" Тогда
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	Иначе	
		Ответ.УстановитьТелоИзСтроки(ТекстОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	КонецЕсли;	
	
	ЗаголовокHTTP = Новый Соответствие();  
	ЗаголовокHTTP.Вставить("Content-type", "application/json;charset=utf-8");

	Ответ.Заголовки = ЗаголовокHTTP;;
	
	Возврат Ответ;

КонецФункции

﻿Процедура СформироватьЗаписиРС() Экспорт

	Запрос = Новый Запрос;
	
	НЗ = РегистрыСведений.ИА_ЦО_АлгоритмыРознЦеныПоЦенамКонкурентов.СоздатьНаборЗаписей();
	НЗ.Отбор.СсылкаСправочник.Установить(Ссылка);
	НЗ.Отбор.СсылкаСправочник.ВидСравнения = ВидСравнения.Равно;
	НЗ.Отбор.СсылкаСправочник.Использование = Истина;
	НЗ.Прочитать();
	НЗ.Очистить();
	
	Если Кейс = Перечисления.ИА_ЦО_ТипыКейсовАлгоритмВыравниванияРЦпоЦК.ВесьАссортимент Тогда
	
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	АССОРТИМЕНТНЫЙ_ПЛАН.Код КАК Код
		|ИЗ
		|	Справочник.АССОРТИМЕНТНЫЙ_ПЛАН КАК АССОРТИМЕНТНЫЙ_ПЛАН
		|ГДЕ
		|	АССОРТИМЕНТНЫЙ_ПЛАН.ЭтоГруппа = ЛОЖЬ";
		Запрос.Текст = ТекстЗапроса;
		ВыборкаАП = Запрос.Выполнить().Выбрать();
		Пока ВыборкаАП.Следующий() Цикл
		
			СтрокаНЗ = НЗ.Добавить();
			СтрокаНЗ.Код1С					= ВыборкаАП.Код;
			СтрокаНЗ.СсылкаСправочник		= Ссылка;
			СтрокаНЗ.Алгоритм				= Алгоритм;
			СтрокаНЗ.Приоритет				= 7;
			СтрокаНЗ.ДатаНачалаДействия		= ДатаНачалаДействия;
			СтрокаНЗ.ДатаОкончанияДействия	= ДатаОкончанияДействия;
		
		КонецЦикла;
	
	ИначеЕсли Кейс = Перечисления.ИА_ЦО_ТипыКейсовАлгоритмВыравниванияРЦпоЦК.ЦеноваяГруппа Тогда
	 	// Ценовые группы не записываем, т.к. мы не знаем к какому конкретно товару 1С относится данный элемент справочника
	ИначеЕсли Кейс = Перечисления.ИА_ЦО_ТипыКейсовАлгоритмВыравниванияРЦпоЦК.Спрос
		ИЛИ Кейс = Перечисления.ИА_ЦО_ТипыКейсовАлгоритмВыравниванияРЦпоЦК.КатегорияТовара 
		ИЛИ Кейс = Перечисления.ИА_ЦО_ТипыКейсовАлгоритмВыравниванияРЦпоЦК.Бренд 
		ИЛИ Кейс = Перечисления.ИА_ЦО_ТипыКейсовАлгоритмВыравниванияРЦпоЦК.Производитель Тогда
		
		Если Кейс = Перечисления.ИА_ЦО_ТипыКейсовАлгоритмВыравниванияРЦпоЦК.Спрос Тогда
			НомерПриоритета = 5;
			ИмяРеквизита = "Спрос";
		ИначеЕсли Кейс = Перечисления.ИА_ЦО_ТипыКейсовАлгоритмВыравниванияРЦпоЦК.КатегорияТовара Тогда
		    НомерПриоритета = 4;
			ИмяРеквизита = "НоваяКатегория";
		ИначеЕсли Кейс = Перечисления.ИА_ЦО_ТипыКейсовАлгоритмВыравниванияРЦпоЦК.Бренд Тогда
		    НомерПриоритета = 3;
			ИмяРеквизита = "Бренд";
		ИначеЕсли Кейс = Перечисления.ИА_ЦО_ТипыКейсовАлгоритмВыравниванияРЦпоЦК.Производитель Тогда
		    НомерПриоритета = 2;
			ИмяРеквизита = "Производитель";
		КонецЕсли; 
		
		Если ТипУсловияПризнака = "=" Тогда
		
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.Код КАК Код
			|ИЗ
			|	Справочник.АССОРТИМЕНТНЫЙ_ПЛАН КАК АССОРТИМЕНТНЫЙ_ПЛАН
			|ГДЕ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.ЭтоГруппа = ЛОЖЬ
			|	И АССОРТИМЕНТНЫЙ_ПЛАН."+ИмяРеквизита+" = &Параметр";
			Запрос.Текст = ТекстЗапроса;
			Запрос.УстановитьПараметр("Параметр", Признак);
			ВыборкаАП = Запрос.Выполнить().Выбрать();
		
		ИначеЕсли ТипУсловияПризнака = "<>" Тогда
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.Код КАК Код
			|ИЗ
			|	Справочник.АССОРТИМЕНТНЫЙ_ПЛАН КАК АССОРТИМЕНТНЫЙ_ПЛАН
			|ГДЕ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.ЭтоГруппа = ЛОЖЬ
			|	И АССОРТИМЕНТНЫЙ_ПЛАН."+ИмяРеквизита+" <> &Параметр";
			Запрос.Текст = ТекстЗапроса;
			Запрос.УстановитьПараметр("Параметр", Признак);
			ВыборкаАП = Запрос.Выполнить().Выбрать();
			
		ИначеЕсли ТипУсловияПризнака = "В списке" Тогда
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.Код КАК Код
			|ИЗ
			|	Справочник.АССОРТИМЕНТНЫЙ_ПЛАН КАК АССОРТИМЕНТНЫЙ_ПЛАН
			|ГДЕ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.ЭтоГруппа = ЛОЖЬ
			|	И АССОРТИМЕНТНЫЙ_ПЛАН."+ИмяРеквизита+" в (&Параметр)";
		
			Запрос.Текст = ТекстЗапроса;
			Запрос.УстановитьПараметр("Параметр", ПризнакСписком.ВыгрузитьКолонку("ПризнакЗначение"));
			ВыборкаАП = Запрос.Выполнить().Выбрать();
			
		ИначеЕсли ТипУсловияПризнака = "Не в списке" Тогда
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.Код КАК Код
			|ИЗ
			|	Справочник.АССОРТИМЕНТНЫЙ_ПЛАН КАК АССОРТИМЕНТНЫЙ_ПЛАН
			|ГДЕ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.ЭтоГруппа = ЛОЖЬ
			|	И НЕ АССОРТИМЕНТНЫЙ_ПЛАН."+ИмяРеквизита+" в (&Параметр)";
			Запрос.Текст = ТекстЗапроса;
			Запрос.УстановитьПараметр("Параметр", ПризнакСписком.ВыгрузитьКолонку("ПризнакЗначение"));
			ВыборкаАП = Запрос.Выполнить().Выбрать();
		
		КонецЕсли;
		
		Пока ВыборкаАП.Следующий() Цикл
			
			СтрокаНЗ = НЗ.Добавить();
			СтрокаНЗ.Код1С					= ВыборкаАП.Код;
			СтрокаНЗ.СсылкаСправочник		= Ссылка;
			СтрокаНЗ.Алгоритм				= Алгоритм;
			СтрокаНЗ.Приоритет				= НомерПриоритета;
			СтрокаНЗ.ДатаНачалаДействия		= ДатаНачалаДействия;
			СтрокаНЗ.ДатаОкончанияДействия	= ДатаОкончанияДействия;
			
		КонецЦикла;
		
	ИначеЕсли Кейс = Перечисления.ИА_ЦО_ТипыКейсовАлгоритмВыравниванияРЦпоЦК.Список Тогда
		
		 НомерПриоритета = 1;
		Если ТипУсловияПризнака = "В списке" Тогда
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.Код КАК Код
			|ИЗ
			|	Справочник.АССОРТИМЕНТНЫЙ_ПЛАН КАК АССОРТИМЕНТНЫЙ_ПЛАН
			|ГДЕ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.ЭтоГруппа = ЛОЖЬ
			|	И АССОРТИМЕНТНЫЙ_ПЛАН.Код В(&Параметр)";
		
			Запрос.Текст = ТекстЗапроса;
			Запрос.УстановитьПараметр("Параметр", Список.ВыгрузитьКолонку("Код1С"));
			ВыборкаАП = Запрос.Выполнить().Выбрать();
			
		ИначеЕсли ТипУсловияПризнака = "Не в списке" Тогда
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.Код КАК Код
			|ИЗ
			|	Справочник.АССОРТИМЕНТНЫЙ_ПЛАН КАК АССОРТИМЕНТНЫЙ_ПЛАН
			|ГДЕ
			|	АССОРТИМЕНТНЫЙ_ПЛАН.ЭтоГруппа = ЛОЖЬ
			|	И НЕ АССОРТИМЕНТНЫЙ_ПЛАН.Код В (&Параметр)";
			Запрос.Текст = ТекстЗапроса;
			Запрос.УстановитьПараметр("Параметр", Список.ВыгрузитьКолонку("Код1С"));
			ВыборкаАП = Запрос.Выполнить().Выбрать();
			
		КонецЕсли;
		
		Пока ВыборкаАП.Следующий() Цикл
			
			СтрокаНЗ = НЗ.Добавить();
			СтрокаНЗ.Код1С					= ВыборкаАП.Код;
			СтрокаНЗ.СсылкаСправочник		= Ссылка;
			СтрокаНЗ.Алгоритм				= Алгоритм;
			СтрокаНЗ.Приоритет				= НомерПриоритета;
			СтрокаНЗ.ДатаНачалаДействия		= ДатаНачалаДействия;
			СтрокаНЗ.ДатаОкончанияДействия	= ДатаОкончанияДействия;
			
		КонецЦикла;
		
	КонецЕсли; 	

	НЗ.Записать();
	
КонецПроцедуры

Процедура УдалитьЗаписиРС() Экспорт

	НЗ = РегистрыСведений.ИА_ЦО_АлгоритмыРознЦеныПоЦенамКонкурентов.СоздатьНаборЗаписей();
	НЗ.Отбор.СсылкаСправочник.Установить(Ссылка);
	НЗ.Отбор.СсылкаСправочник.ВидСравнения = ВидСравнения.Равно;
	НЗ.Отбор.СсылкаСправочник.Использование = Истина;
	НЗ.Прочитать();
	НЗ.Очистить();
	НЗ.Записать();
	
КонецПроцедуры
 
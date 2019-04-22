﻿
Процедура ПоместитьВОбменСкладБух() Экспорт
	
вЫГ=нОВЫЙ Запрос();
вЫГ.Текст=
"ВЫБРАТЬ
|	204 КАК ВидДокумента,
|	ФД.ФирмаКод КАК КодФирмы,
|	""гуиддокументаполучаетсяпослевыборкиизссылкинадокумент"" КАК СсылкаТХТ,
|	ФД.Ссылка.Дата КАК ДатаОчередиСклад,
|	ФД.Ссылка.Склад.Код КАК КодСклада,
|	0 КАК КодКонтрагента,
|	ФД.Ссылка КАК Объект,
|	ФД.Ссылка.Проведен КАК Проведен,
|	ФД.Ссылка.ПометкаУдаления КАК ПомеченНаУдаление,
|	"""" КАК ОшибкаПриЗагрузке,
|	ФД.ФирмаКомитентКод
|ИЗ
|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
|		ФирмыДокумента.ФирмаКод КАК ФирмаКод,
|		ЕСТЬNULL(Фирмы.Код, 0) КАК ФирмаКомитентКод,
|		ФирмыДокумента.Ссылка КАК Ссылка
|	ИЗ
|		(ВЫБРАТЬ РАЗЛИЧНЫЕ
|			УЗ_ВозвратОтПокупателяТовар.Ссылка.Фирма.Код КАК ФирмаКод,
|			УЗ_Партии.ПоставщикКомитентВнутренний КАК ПоставщикКомитентВнутренний,
|			УЗ_ВозвратОтПокупателяТовар.Ссылка КАК Ссылка
|		ИЗ
|			Документ.УЗ_ВозвратОтПокупателя.Товар КАК УЗ_ВозвратОтПокупателяТовар
|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УЗ_Партии КАК УЗ_Партии
|				ПО УЗ_ВозвратОтПокупателяТовар.КодПартии = УЗ_Партии.Код
|		ГДЕ
|			УЗ_ВозвратОтПокупателяТовар.Ссылка = &Ссылка) КАК ФирмыДокумента
|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Фирмы КАК Фирмы
|			ПО ФирмыДокумента.ПоставщикКомитентВнутренний = Фирмы.ФирмаКакПоставщик.Код
|				И (ФирмыДокумента.ПоставщикКомитентВнутренний <> 0)) КАК ФД"; // Сгенерировано в GtG's Консоль запросов. 13.04.2016 23:44:27

    
    Выг.УстановитьПараметр("Ссылка",Ссылка);
    
    РезВыг=Выг.Выполнить();
    
    ВыбРезВыг=РезВыг.Выбрать();
    
    Пока ВыбРезВыг.Следующий() Цикл
        
        МЗ=РегистрыСведений.ОбменСкладБух.СоздатьМенеджерЗаписи();
        
        ЗаполнитьЗначенияСвойств(МЗ,ВыбРезВыг);
        
        МЗ.СсылкаТХТ=Ссылка.УникальныйИдентификатор();
        
        МЗ.Записать();
        
        Если ВыбРезВыг.ФирмаКомитентКод<>0 Тогда
            
            МЗ=РегистрыСведений.ОбменСкладБух.СоздатьМенеджерЗаписи();
            
            ЗаполнитьЗначенияСвойств(МЗ,ВыбРезВыг);
            
            МЗ.СсылкаТХТ=Ссылка.УникальныйИдентификатор();
            МЗ.КодФирмы= ВыбРезВыг.ФирмаКомитентКод;
            МЗ.Записать();
            
            
        КонецЕСли;
    КонецЦикла;    

	
	
КонецПроцедуры

Процедура ПроверитьНаЗаполнение(Отказ)
	

	Если НЕ Товар.Найти(0,"Коэфф") = Неопределено Тогда
			#Если Клиент Тогда
				Сообщить("В документе есть строки с коэффициентами =0!
					|Это недопустимо!
					|Очевидно проблемы с единицами товаров.");
				ПроведениеЗакончено=Истина;
			#КонецЕсли
			Отказ = Истина;
			Возврат ;
	КонецЕсли;

	Если НЕ Товар.Найти(0,"ЦенаЗакупБезНДС") = Неопределено Тогда
		// Есть строки с 0-ми
		#Если Клиент Тогда
			Сообщить("В документе есть строки без закуп. цены!
			|Это недопустимо!
			|Укажите цену закупочную!");
		#КонецЕсли
		ПроведениеЗакончено=Истина;

		Отказ = ИСТИНА;
		Возврат ;
	КонецЕсли;

	
КонецПроцедуры

Процедура ПодготовитьТаблицыДвижений(ТаблицыДвижений)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.УстановитьПараметр("Дата",Дата);
	Запрос.УстановитьПараметр("СкладКод",Склад.Код);
	Запрос.УстановитьПараметр("ФирмаКод",Фирма.Код);
	Запрос.УстановитьПараметр("Склад",Склад);
	
	Запрос.УстановитьПараметр("КачествоТовараПорядок",Перечисления.УЗ_КачествоТовара.Индекс(Перечисления.УЗ_КачествоТовара.ХорошийТовар));
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	&СкладКод КАК СкладКод,
	               |	&ФирмаКод КАК ФирмаКод,
	               |	Партии.ВидПоступления КАК ВидПоступленияПорядок,
	               |	&КачествоТовараПорядок КАК КачествоТовараПорядок,
	               |	ТЧТовар.КодПартии КАК ПартияКод,
	               |	ТЧТовар.КодТовара КАК ТоварКод,
	               |	ТЧТовар.Количество * ТЧТовар.Коэфф КАК Количество,
	               |	ТЧТовар.Коэфф,
	               |	Партии.СтавкаНДСЗакуп,
	               |	ТЧТовар.СтавкаНДС,
	               |	ТЧТовар.СуммаЗакупБезНДС
	               |ПОМЕСТИТЬ ВтТовары
	               |ИЗ
	               |	Документ.УЗ_ВозвратОтПокупателя.Товар КАК ТЧТовар
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УЗ_Партии КАК Партии
	               |		ПО (Партии.Код = ТЧТовар.КодПартии)
	               |ГДЕ
	               |	ТЧТовар.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТТовары.СкладКод,
	               |	ВТТовары.ФирмаКод,
	               |	ВТТовары.ВидПоступленияПорядок,
	               |	ВТТовары.ПартияКод,
	               |	ВТТовары.ТоварКод,
	               |	ВТТовары.СтавкаНДСЗакуп,
	               |	ВТТовары.СуммаЗакупБезНДС,
	               |	ВТТовары.Количество,
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	               |	&Дата КАК Период
	               |ИЗ
	               |	ВтТовары КАК ВТТовары
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТТовары.СкладКод,
	               |	ВТТовары.ФирмаКод,
	               |	ВТТовары.КачествоТовараПорядок,
	               |	ВТТовары.ВидПоступленияПорядок,
	               |	ВТТовары.СтавкаНДС,
	               |	СУММА(ВТТовары.СуммаЗакупБезНДС) КАК СуммаЗакупБезНДС,
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	               |	&Дата КАК Период,
	               |	0 КАК СуммаОкругления
	               |ИЗ
	               |	ВтТовары КАК ВТТовары
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВТТовары.СкладКод,
	               |	ВТТовары.ФирмаКод,
	               |	ВТТовары.ВидПоступленияПорядок,
	               |	ВТТовары.КачествоТовараПорядок,
	               |	ВТТовары.СтавкаНДС
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТТовары";
				   
			Результат = Запрос.ВыполнитьПакет();	   
			ТаблицыДвижений.Вставить("УЗ_Партии",				                        Результат[1].Выгрузить());
			ТаблицыДвижений.Вставить("УЗ_ТоварныйОтчет",			                    Результат[2].Выгрузить());
				   
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	 
 
	
	ТаблицыДвижений = Новый Структура();
	
	ПодготовитьТаблицыДвижений(ТаблицыДвижений);
	
	Таблица= ТаблицыДвижений.УЗ_Партии;
	Движения.УЗ_Партии.Записывать = Истина;
	Движения.УЗ_Партии.Загрузить(Таблица);	
	
	
	Таблица= ТаблицыДвижений.УЗ_ТоварныйОтчет;
	Движения.УЗ_ТоварныйОтчет.Записывать = Истина;
	Движения.УЗ_ТоварныйОтчет.Загрузить(Таблица);

	ПоместитьВОбменСкладБух();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатаПоследнегоИзменения = ТекущаяДата();
	СуммаЗакупБезНДС = Товар.Итог("СуммаЗакупБезНДС");
	СуммаРозн = Товар.Итог("СуммаРозн");

	
	Если НЕ ЭтоНовый() Тогда
		Если Год(Дата)>Год(Ссылка.Дата) Тогда
			УстановитьНовыйНомер();
		КонецЕсли;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьНаЗаполнение(Отказ);	
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ОМ41_ПередУдалениемДокумента  (ЭтотОбъект,Отказ);
		Если Отказ = Истина Тогда
			Возврат;
		КонецЕсли;		
	КонецЕсли;

	ОбщегоНазначения.ЗаписатьСменуСостоянияДокумента(Ссылка,РежимЗаписи,ПометкаУдаления);
	
	
	
КонецПроцедуры


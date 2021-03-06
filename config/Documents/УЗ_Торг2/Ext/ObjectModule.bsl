﻿ 
Процедура ПроверитьНаЗаполнение(Отказ)
	
	 Если ДокументПоступления.Пустая() Тогда
		 #Если Клиент Тогда
			 Сообщить("Не указан документ поступления! Документ не проведен",СтатусСообщения.ОченьВажное);	 
		 #КонецЕсли	
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если Поставщик.Пустая() Тогда
		 #Если Клиент Тогда
			 Сообщить("Не указан поставщик! Документ не проведен",СтатусСообщения.ОченьВажное);	 
		 #КонецЕсли	
		Отказ = Истина;
		Возврат;
	КонецЕсли;	

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
	
	КачествоТовараХТ = Перечисления.УЗ_КачествоТовара.Индекс(Перечисления.УЗ_КачествоТовара.ХорошийТовар);
	//КачествоТовараНедовоз = Перечисления.УЗ_КачествоТовара.Индекс(Перечисления.УЗ_КачествоТовара.Недовоз);
	КачествоТовараБрак = Перечисления.УЗ_КачествоТовара.Индекс(Перечисления.УЗ_КачествоТовара.Брак);
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.УстановитьПараметр("Дата",Дата);
	Запрос.УстановитьПараметр("СкладКод",Склад.Код);
	Запрос.УстановитьПараметр("ФирмаКод",Фирма.Код);
	Запрос.УстановитьПараметр("Склад",Склад);
	Запрос.УстановитьПараметр("КачествоТовараХТ",КачествоТовараХТ);
	//Запрос.УстановитьПараметр("КачествоТовараНедовоз",КачествоТовараНедовоз);
	Запрос.УстановитьПараметр("КачествоТовараБрак",КачествоТовараБрак);
	
	
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	&СкладКод КАК СкладКод,
	               |	&ФирмаКод КАК ФирмаКод,
	               |	Партии.ВидПоступления КАК ВидПоступленияПорядок,
	               |	ТЧТовар.КодПартии КАК ПартияКод,
	               |	ТЧТовар.КодТовара КАК ТоварКод,
	               |	ТЧТовар.БойБрак * ТЧТовар.Коэфф КАК КоличествоБойБрак,
	               |	ТЧТовар.Недовоз * ТЧТовар.Коэфф КАК КоличествоНедовоз,
	               |	ТЧТовар.Коэфф,
	               |	ТЧТовар.СтавкаНДСЗакуп,
				   |	ТЧТовар.СуммаЗакупБезНДС/(ТЧТовар.БойБрак * ТЧТовар.Коэфф + ТЧТовар.Недовоз * ТЧТовар.Коэфф) * (ТЧТовар.БойБрак * ТЧТовар.Коэфф) как СуммаБрака,
				   |	ТЧТовар.СуммаЗакупБезНДС/(ТЧТовар.БойБрак * ТЧТовар.Коэфф + ТЧТовар.Недовоз * ТЧТовар.Коэфф) * (ТЧТовар.Недовоз * ТЧТовар.Коэфф) как СуммаНедовоза,
	               |	ТЧТовар.СуммаЗакупБезНДС
	               |ПОМЕСТИТЬ ВТТовары
	               |ИЗ
	               |	Документ.УЗ_Торг2.Товар КАК ТЧТовар
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УЗ_Партии КАК Партии
	               |		ПО (Партии.Код = ТЧТовар.КодПартии)
	               |ГДЕ
	               |	ТЧТовар.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
				   |// 1. Расход все из Партий :  УЗ_Партии
	               |ВЫБРАТЬ
	               |	ВТТовары.СкладКод КАК СкладКод,
	               |	ВТТовары.ФирмаКод КАК ФирмаКод,
	               |	ВТТовары.ВидПоступленияПорядок КАК ВидПоступленияПорядок,
	               |	ВТТовары.ПартияКод,
	               |	ВТТовары.ТоварКод,
	               |	ВТТовары.СтавкаНДСЗакуп,
	               |	ВТТовары.СуммаЗакупБезНДС,
	               |	ВТТовары.КоличествоНедовоз+КоличествоБойБрак КАК Количество,
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	               |	&Дата КАК Период
	               |ИЗ
	               |	ВТТовары КАК ВТТовары
	               |;
	               |
				   |// 2. Приход недовоза в партии недовоза :  УЗ_ПартииНедовоз
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТТовары.СкладКод КАК СкладКод,
	               |	ВТТовары.ФирмаКод КАК ФирмаКод,
	               |	ВТТовары.ВидПоступленияПорядок КАК ВидПоступленияПорядок,
	               |	ВТТовары.ПартияКод,
	               |	ВТТовары.ТоварКод,
	               |	ВТТовары.СтавкаНДСЗакуп,
	               |	ВТТовары.СуммаНедовоза как СуммаЗакупБезНДС,
	               |	ВТТовары.КоличествоНедовоз КАК Количество,
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	               |	&Дата КАК Период
	               |ИЗ
	               |	ВТТовары КАК ВТТовары
	               |ГДЕ
	               |	ВТТовары.КоличествоНедовоз > 0
	               |;
	               |
				   |// 3. Расход всего из ТО + приход БойБрака в ТО под видом бойбрака :  УЗ_ТоварныйОтчет
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТТовары.СкладКод,
	               |	ВТТовары.ФирмаКод,
	               |	&КачествоТовараХТ КАК КачествоТовараПорядок,
	               |	ВТТовары.ВидПоступленияПорядок,
	               |	ВТТовары.СтавкаНДСЗакуп КАК СтавкаНДС,
	               |	СУММА(ВТТовары.СуммаЗакупБезНДС) КАК СуммаЗакупБезНДС,
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	               |	&Дата КАК Период,
	               |	0 КАК СуммаОкругления
	               |ИЗ
	               |	ВТТовары КАК ВТТовары
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВТТовары.СкладКод,
	               |	ВТТовары.ФирмаКод,
	               |	ВТТовары.ВидПоступленияПорядок,
	               |	ВТТовары.СтавкаНДСЗакуп
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ВТТовары.СкладКод,
	               |	ВТТовары.ФирмаКод,
	               |	&КачествоТовараБрак,
	               |	ВТТовары.ВидПоступленияПорядок,
	               |	ВТТовары.СтавкаНДСЗакуп,
	               |	СУММА(ВТТовары.СуммаБрака ) как СуммаЗакупБезНДС,
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	               |	&Дата,
	               |	0
	               |ИЗ
	               |	ВТТовары КАК ВТТовары
	               |ГДЕ
	               |	ВТТовары.КоличествоБойБрак > 0
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВТТовары.СкладКод,
	               |	ВТТовары.ФирмаКод,
	               |	ВТТовары.ВидПоступленияПорядок,
	               |	ВТТовары.СтавкаНДСЗакуп
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
				   |// 4. Приход БойБрака в партии бой брака :  УЗ_ПартииБрак
	               |ВЫБРАТЬ
	               |	ВТТовары.СкладКод КАК СкладКод,
	               |	ВТТовары.ФирмаКод КАК ФирмаКод,
	               |	ВТТовары.ВидПоступленияПорядок КАК ВидПоступленияПорядок,
	               |	ВТТовары.ПартияКод,
	               |	ВТТовары.ТоварКод,
	               |	ВТТовары.СтавкаНДСЗакуп,
	               |	ВТТовары.СуммаБрака как СуммаЗакупБезНДС,
	               |	ВТТовары.КоличествоБойБрак КАК Количество,
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	               |	&Дата КАК Период
	               |ИЗ
	               |	ВТТовары КАК ВТТовары
	               |ГДЕ
	               |	ВТТовары.КоличествоБойБрак > 0
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТТовары";
				   
			Результат = Запрос.ВыполнитьПакет();	   
			ТаблицыДвижений.Вставить("УЗ_Партии",				                        Результат[1].Выгрузить());
			ТаблицыДвижений.Вставить("УЗ_ПартииНедовоз",		                        Результат[2].Выгрузить());
			ТаблицыДвижений.Вставить("УЗ_ТоварныйОтчет",			                    Результат[3].Выгрузить());
			ТаблицыДвижений.Вставить("УЗ_ПартииБрак",			                        Результат[4].Выгрузить());
				   
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	 
	 
	ТаблицыДвижений = Новый Структура();
	
	ПодготовитьТаблицыДвижений(ТаблицыДвижений);
	
	Таблица= ТаблицыДвижений.УЗ_Партии;
	
	Движения.УЗ_Партии.Записывать = Истина;
	Движения.УЗ_Партии.Загрузить(Таблица);	
	
	Таблица= ТаблицыДвижений.УЗ_ПартииНедовоз;
	Движения.УЗ_ПартииНедовоз.Записывать = Истина;
	Движения.УЗ_ПартииНедовоз.Загрузить(Таблица);		
	
	Таблица= ТаблицыДвижений.УЗ_ПартииБрак;
	Движения.УЗ_ПартииБрак.Записывать = Истина;
	Движения.УЗ_ПартииБрак.Загрузить(Таблица);		
	
	Таблица= ТаблицыДвижений.УЗ_ТоварныйОтчет;
	Движения.УЗ_ТоварныйОтчет.Записывать = Истина;
	Движения.УЗ_ТоварныйОтчет.Загрузить(Таблица);
	
	ПоместитьВОбменСкладБух();
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатаПоследнегоИзменения = ТекущаяДата();
	СуммаЗакупБезНДС = Товар.Итог("СуммаЗакупБезНДС");
	
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


//GTG 15-03-2016
Процедура ПоместитьВОбменСкладБух() Экспорт
	//GTG 15-03-2016
	// Принудительно ставим в обмен документ основание, если Чо - проигнорируется при загрузке и уйдет из обмена
	Если НЕ ДокументПоступления.Пустая() Тогда // не важно что там с датой факт пост, т.к. теперь уже есть движуха по торг-2
		МЗ = РегистрыСведений.ОбменСкладБух.СоздатьМенеджерЗаписи();
		МЗ.ВидДокумента = 201;
		МЗ.ДатаОчередиСклад = Дата;
		МЗ.КодФирмы = ДокументПоступления.Фирма.Код;
		МЗ.СсылкаТХТ = XMLСтрока(ДокументПоступления);
		МЗ.КодСклада = ДокументПоступления.Склад.Код;
		МЗ.КодКонтрагента = ДокументПоступления.Поставщик.Код;
		МЗ.Объект = ДокументПоступления;
		МЗ.Проведен = Истина;
		МЗ.ПомеченНаУдаление = Ложь;
		МЗ.Записать();
		Если НЕ ДокументПоступления.ФирмаКомитент.Пустая() Тогда
			МЗ = РегистрыСведений.ОбменСкладБух.СоздатьМенеджерЗаписи();
			МЗ.ВидДокумента = 201;
			МЗ.ДатаОчередиСклад = Дата;
			МЗ.КодФирмы = ДокументПоступления.ФирмаКомитент.Код;
			МЗ.СсылкаТХТ = XMLСтрока(ДокументПоступления);
			МЗ.КодСклада = ДокументПоступления.Склад.Код;
			МЗ.КодКонтрагента = ДокументПоступления.Поставщик.Код;
			МЗ.Объект = ДокументПоступления;
			МЗ.Проведен = Истина;
			МЗ.ПомеченНаУдаление = Ложь;
			МЗ.Записать();			
		КонецЕсли;
	КонецЕсли;
	
	// выгружаем сам торг-2 по всем фирмам которые засветились в документе основании
	
	
	МЗ = РегистрыСведений.ОбменСкладБух.СоздатьМенеджерЗаписи();
	МЗ.ВидДокумента = 202;
	МЗ.ДатаОчередиСклад = Дата;
	МЗ.КодФирмы = Фирма.Код;
	МЗ.СсылкаТХТ = XMLСтрока(Ссылка);
	МЗ.КодСклада = Склад.Код;
	МЗ.КодКонтрагента = Поставщик.Код;
	МЗ.Объект = Ссылка;
	МЗ.Проведен = Истина;
	МЗ.ПомеченНаУдаление = Ложь;
	МЗ.Записать();
	Если НЕ ДокументПоступления.ФирмаКомитент.Пустая() Тогда
		МЗ = РегистрыСведений.ОбменСкладБух.СоздатьМенеджерЗаписи();
		МЗ.ВидДокумента = 202;
		МЗ.ДатаОчередиСклад = Дата;
		МЗ.КодФирмы = ДокументПоступления.ФирмаКомитент.Код;
		МЗ.СсылкаТХТ = XMLСтрока(Ссылка);
		МЗ.КодСклада = Склад.Код;
		МЗ.КодКонтрагента = Поставщик.Код;
		МЗ.Объект = Ссылка;
		МЗ.Проведен = Истина;
		МЗ.ПомеченНаУдаление = Ложь;
		МЗ.Записать();			
	КонецЕсли;
	

	
	
	
	
КонецПроцедуры

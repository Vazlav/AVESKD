﻿Функция ВыгрузитьРезультатРасценкиМодуль() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Ошибка",Ложь);
	Результат.Вставить("ОписаниеОшибки","");	
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	Перерасценка366Товар.КодТовара366,
	               |	Перерасценка366Товар.ЦенаПубликации
	               |ИЗ
	               |	Документ.Перерасценка366.Товар КАК Перерасценка366Товар
	               |ГДЕ
	               |	Перерасценка366Товар.Ссылка = &Ссылка
	               |	И Перерасценка366Товар.Публикация = ИСТИНА
	               |	И Перерасценка366Товар.ЦенаПубликации > 0";
	Рез = Запрос.Выполнить();
	Если Рез.Пустой() Тогда
		Результат.Ошибка = Истина;
		Результат.ОписаниеОшибки = "Нет данных для выгрузки в файл. Документ:  " + Ссылка;		
		Возврат Результат;
	КонецЕсли;
	
	
	Выборка = Рез.Выбрать();
	
	Т = Новый ТекстовыйДокумент;
	Шапка = 
			"""RCV_LOC"";"+
			"""EITEM"";"+
			"""RTL_PRICE""";
	
	
	Т.ДобавитьСтроку(Шапка);
	
	КодАптеки = Формат(Склад.Код77,"ЧГ=0");
	
	Пока выборка.Следующий() Цикл
		
		Тело =	"""" + КодАптеки	+ """;" + 		
				"""" + Выборка.КодТовара366	+ """;" + 				
				"""" + Формат(Выборка.ЦенаПубликации,"ЧРД=.; ЧГ=")	+ """" ; 								
				
		Т.ДобавитьСтроку(Тело);
		
	КонецЦикла;
	
	ИмяФайла = "\\id-vm-1\ftp_data\a366\price_formation\out\" + КодАптеки + "_" + Формат(ТекущаяДата(),"ДФ=yyyyMMdd_HHmmss") + ".csv";
	Попытка
		Т.Записать(ИмяФайла,"windows-1251");
	Исключение
		Результат.Ошибка = Истина;
		Результат.ОписаниеОшибки = "Не удалось записать файл: " + ИмяФайла;		
		#Если Клиент Тогда
			Сообщить("Не удалось записать файл: " + ИмяФайла );	
		#КонецЕсли
		Возврат Результат;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ЗаполнитьДокумент(Соединение,КодАптеки,КоличествоДокументов) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Ошибка",Ложь);
	Результат.Вставить("ОписаниеОшибки","");
	
	Если Соединение = Неопределено Тогда
		Результат.Ошибка = Истина;
		Результат.ОписаниеОшибки = "Нет соединения с внешним источником данных.";
		#Если Клиент Тогда
			Предупреждение("Невозможно получить документы. Нет соединения с внешним источником.");
		#КонецЕсли
		Возврат Результат;
	КонецЕсли;
	
	
	
	ТХТ = "select * from a366.get_dcm('" + СокрЛП(КодАптеки) + "','" + Формат(КоличествоДокументов,"ЧГ=0")+ "')";
	RecordSet = ОМ_ТП.ВыполнитьЗапросНаВнешнемИсточнике(Соединение,ТХТ);
	Если RecordSet = Неопределено Тогда
		Результат.Ошибка = Истина;
		Результат.ОписаниеОшибки = "Запрос вернул пустой набор записей. Нет данных для заполнения.";
		#Если Клиент Тогда
			Предупреждение("Запрос вернул пустой набор записей. Нет данных для заполнения.");
		#КонецЕсли
		Возврат Результат;

	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ТХТ = "ВЫБРАТЬ
	      |	АП.Код,
	      |	АП.Ссылка,
	      |	АП.ЕдиницаПоУмолчанию.К КАК Коэфф,
		  | АП.ЖНВЛС
	      |ИЗ
	      |	Справочник.АССОРТИМЕНТНЫЙ_ПЛАН КАК АП
	      |
	      |УПОРЯДОЧИТЬ ПО
	      |	АП.Код";
	Запрос.Текст = ТХТ;
	
	ТЗАП = Запрос.Выполнить().Выгрузить();
	ТзАП.Индексы.Добавить("Код");
	
	
	ТХТ = "ВЫБРАТЬ
	      |	Поставщики.Ссылка как Поставщик,
	      |	Поставщики.ИНН +  ""-"" + Поставщики.КПП как ИННКПП
	      |	
	      |ИЗ
	      |	Справочник.Поставщики КАК Поставщики
	      |ГДЕ
	      |	Поставщики.ИНН <> """" ";
		  
		  Запрос.Текст = ТХТ;
	ТЗПост = Запрос.Выполнить().Выгрузить();
	ТЗПост.Индексы.Добавить("ИННКПП");
	
	
	Пока Не RecordSet.EOF() Цикл
		
		КодТовараАВЕ =  RecordSet.Fields("item_ave").VAlue;
		Если КодТовараАВЕ  = NULL Тогда
			НайденнаяСтрока = Неопределено;
		Иначе
			НайденнаяСтрока =  ТЗАП.Найти(КодТовараАВЕ, "Код");
		КонецЕсли;
		
		
		стр = Товар.Добавить();
		Если НЕ НайденнаяСтрока = Неопределено  Тогда
			стр.Товар			=НайденнаяСтрока.Ссылка;
			стр.Сопоставлен		=Истина;
			стр.Коэфф				= НайденнаяСтрока.Коэфф;
			стр.ЖНВЛС				= НайденнаяСтрока.ЖНВЛС;

		Иначе
			стр.Коэфф				= RecordSet.Fields("QNT_IN_BOX").VAlue;
			стр.ЖНВЛС 				= RecordSet.Fields("IS_LIFECRITICAL").VAlue;			
		КонецЕсли;
		стр.Количество			= RecordSet.Fields("QNT").VAlue;
		//RecordSet.Fields("QNT_IN_BOX").VAlue;
		стр.СтавкаНДС			= Справочники.СтавкиНДС.НайтиПоРеквизиту("Ставка",RecordSet.Fields("VAT_RATE").VAlue);
		стр.ЦенаЗакупБезНДС		= RecordSet.Fields("PUR_COST_WO_NDS").VAlue;
		стр.ЦенаЗакуп			= RecordSet.Fields("PUR_COST").VAlue;
		стр.ЦенаГосрегистрации	= RecordSet.Fields("REG_COST").VAlue;
		стр.Ценапроизводителя	= RecordSet.Fields("MAN_COST").VAlue;
		стр.ЦенаРознСтарая		= RecordSet.Fields("RTL_PRICE").VAlue;
		стр.Партия				= RecordSet.Fields("BATCH").VAlue;
		стр.БарКод				= RecordSet.Fields("ITEM").VAlue;
		стр.КодТовара366		= RecordSet.Fields("EITEM").VAlue;
		стр.НаименованиеТовара366	=RecordSet.Fields("FULL_NAME").VAlue;
		стр.Документ			= RecordSet.Fields("DCM").VAlue;
		стр.СуммаЗакуп			= Стр.Количество*Стр.ЦенаЗакуп;				  
		стр.ГруппаТовара  		= RecordSet.Fields("FPG").VAlue;
		
		ИННКПП				= RecordSet.Fields("SUPP_INN").VAlue + "-" + RecordSet.Fields("SUPP_KPP").VAlue;	
		Если ИННКПП <> "-"  Тогда
			
			НайденнаяСтрока =  ТЗПост.Найти(ИННКПП, "ИННКПП");
			Если НЕ НайденнаяСтрока = Неопределено  Тогда
				стр.Поставщик		=НайденнаяСтрока.Поставщик;
			КонецЕсли;
			
		КонецЕсли;
		
		
		RecordSet.MoveNext();
		
	КонецЦикла;		
	
	
	Возврат Результат;
	
КонецФункции

Функция РасценитьДокумент() Экспорт
	
	ПараметрыРасценки = Новый Структура;
	
	ПараметрыРасценки.Вставить("Авторасценка",Истина) ;
	ПараметрыРасценки.Вставить("Склад",СКЛАД);
	ПараметрыРасценки.Вставить("Документ",Ссылка) ;
	ПараметрыРасценки.Вставить("ТипДокумента",ТипЗнч(Ссылка)) ;
	ПараметрыРасценки.Вставить("ВидДокумента",Метаданные().Имя) ;
	ПараметрыРасценки.Вставить("Комментировать",Ложь);
	ПараметрыРасценки.Вставить("ВыводитьНеРасцененные",Ложь);
	ПараметрыРасценки.Вставить("Регион",Склад.Регион);	
	ПараметрыРасценки.Вставить("ДопРегион",Склад.Регион.ДопРегион);	
	ПараметрыРасценки.Вставить("МинимальныйПроцентНаценкиКромеТопов",0);
	ПараметрыРасценки.Вставить("ЗаписыватьЦеныВРегистрЦен",Ложь);
	ПараметрыРасценки.Вставить("УстановитьрозничныеЦеныВДокументе",Истина);
	ПараметрыРасценки.Вставить("ИспользоватьЦеныКонкурентов",Ложь);
	ПараметрыРасценки.Вставить("ПроверятьЗакупкуИРозницу",Истина);

	
	СтруктураРезультата = Расценка.Расценить366(ПараметрыРасценки);
	ТЗ = СтруктураРезультата.ТП;
	ТЗКосяков = СтруктураРезультата.ТЗКосяков;
	Результат = СтруктураРезультата.Результат;
	КоличествоОшибокРасценки = СтруктураРезультата.КоличествоОшибокРасценки;
	
	Для каждого стр из ТЗ Цикл
		
		Если стр.ЦенаРозн = 0 Тогда
			Продолжить;
		КонецЕсли;
		

		СтрокаТЧ  = Товар.Найти(стр.Партия,"Партия");
		Если НЕ СтрокаТЧ = Неопределено Тогда
			СтрокаТЧ.ПредыдущаяЦена = стр.ПредыдущаяРознЦена;
			СтрокаТЧ.Отклонение = стр.Отклонение;
			СтрокаТЧ.ЦенаРознНовая=стр.ЦенаРозн;	
			СтрокаТЧ.СуммаРознНовая=СтрокаТЧ.ЦенаРознНовая*СтрокаТЧ.Количество;
			
			Если  СтрокаТЧ.СуммаЗакуп<>0 и СтрокаТЧ.СуммаРознНовая<>0 Тогда
				СтрокаТЧ.ПроцентРознНац=(СтрокаТЧ.СуммаРознНовая/СтрокаТЧ.СуммаЗакуп-1)*100;
			ИначеЕсли СтрокаТЧ.ЦенаРознНовая<>0 и СтрокаТЧ.ЦенаЗакуп<>0 ТОГДА
				СтрокаТЧ.ПроцентРознНац=(СтрокаТЧ.ЦенаРознНовая/СтрокаТЧ.ЦенаЗакуп-1)*100;
			КонецЕсли;	
			
			
		КонецЕсли;
	КонецЦикла;
	
	Если ТЗКосяков.Количество()>0 или Результат = Ложь ТОгда
		Результат = Ложь;
		//ЛогОшибок = Новый ТекстовыйДокумент;
		//Попытка
		//	ЛогОшибок.Прочитать("\\id-app-01\common\Санакоев\LogErrPrices.csv");
		//Исключение
		//	ЛогОшибок.Записать("\\id-app-01\common\Санакоев\LogErrPrices.csv",КодировкаТекста.ANSI);
		//КонецПопытки;
		
		Для каждого Стр из ТЗКосяков Цикл
			СтрОп=ОшибкиРасценки.Добавить();
			СтрОП.Товар 	= Стр.Товар;
			СтрОП.Партия 	= Стр.Партия;
			СтрОП.ОписаниеОшибки= Стр.Косяк;
			СтрОП.ЦенаПоРасценке= Стр.ЦенаПоРасценке;
			
			//ЛогОшибок.ДобавитьСтроку(""+Формат(документ.Дата,"ДФ=dd.MM.yyyy") + "|"
			//+ Формат(документ.Номер,"ЧГ=0") + "|"
			//+ ПараметрыРасценки.Склад + "|"
			//+ Стр.Товар + "|"
			//+ Стр.Косяк + "|"
			//+ Стр.ЦенаПоРасценке + "|"
			//+ ПараметрыРасценки.Регион );
			
			
		КонецЦикла;
		//ЛогОшибок.Записать("\\id-app-01\common\Санакоев\LogErrPrices.csv",КодировкаТекста.ANSI);
	КонецЕсли;	
	
	Записать(РежимЗаписиДокумента.Запись);	
	
	Возврат Результат;
	
КонецФункции

Процедура КорректировкаЦен() Экспорт
	
	ТХТ = "ВЫБРАТЬ
	      |	Перерасценка366Товар.КодТовара366,
	      |	Перерасценка366Товар.Партия,
	      |	ВЫБОР
	      |		КОГДА Перерасценка366Товар.ПредыдущаяЦена <= 100
	      |			ТОГДА ВЫБОР
	      |					КОГДА (1 - Перерасценка366Товар.ПредыдущаяЦена / Перерасценка366Товар.ЦенаРознНовая) * 100 < 0
	      |						ТОГДА ВЫБОР
	      |								КОГДА -1 * (1 - Перерасценка366Товар.ПредыдущаяЦена / Перерасценка366Товар.ЦенаРознНовая) * 100 > 50
	      |									ТОГДА ИСТИНА
	      |								ИНАЧЕ ЛОЖЬ
	      |							КОНЕЦ
	      |					КОГДА (1 - Перерасценка366Товар.ПредыдущаяЦена / Перерасценка366Товар.ЦенаРознНовая) * 100 > 0
	      |						ТОГДА ВЫБОР
	      |								КОГДА (1 - Перерасценка366Товар.ПредыдущаяЦена / Перерасценка366Товар.ЦенаРознНовая) * 100 > 20
	      |									ТОГДА ИСТИНА
	      |								ИНАЧЕ ЛОЖЬ
	      |							КОНЕЦ
	      |					ИНАЧЕ ЛОЖЬ
	      |				КОНЕЦ
	      |		ИНАЧЕ ВЫБОР
	      |				КОГДА (1 - Перерасценка366Товар.ПредыдущаяЦена / Перерасценка366Товар.ЦенаРознНовая) * 100 < 0
	      |					ТОГДА ВЫБОР
	      |							КОГДА -1 * (1 - Перерасценка366Товар.ПредыдущаяЦена / Перерасценка366Товар.ЦенаРознНовая) * 100 > 25
	      |								ТОГДА ИСТИНА
	      |							ИНАЧЕ ЛОЖЬ
	      |						КОНЕЦ
	      |				КОГДА (1 - Перерасценка366Товар.ПредыдущаяЦена / Перерасценка366Товар.ЦенаРознНовая) * 100 > 0
	      |					ТОГДА ВЫБОР
	      |							КОГДА (1 - Перерасценка366Товар.ПредыдущаяЦена / Перерасценка366Товар.ЦенаРознНовая) * 100 > 10
	      |								ТОГДА ИСТИНА
	      |							ИНАЧЕ ЛОЖЬ
	      |						КОНЕЦ
	      |				ИНАЧЕ ЛОЖЬ
	      |			КОНЕЦ
	      |	КОНЕЦ КАК Отклонение,
	      |	Перерасценка366Товар.ПредыдущаяЦена,
	      |	Перерасценка366Товар.ЦенаРознНовая,
	      |	Перерасценка366Товар.ЖНВЛС
	      |ПОМЕСТИТЬ ОтклоненияПоПартиям
	      |ИЗ
	      |	Документ.Перерасценка366.Товар КАК Перерасценка366Товар
	      |ГДЕ
	      |	Перерасценка366Товар.Ссылка = &Ссылка
	      |	И Перерасценка366Товар.ЦенаРознНовая > 0
	      |	И Перерасценка366Товар.Сопоставлен = ИСТИНА
	      |	И Перерасценка366Товар.ПредыдущаяЦена > 0
	      |;
	      |
	      |////////////////////////////////////////////////////////////////////////////////
	      |ВЫБРАТЬ
	      |	ОтклоненияПоПартиям.КодТовара366,
	      |	МАКСИМУМ(ОтклоненияПоПартиям.Отклонение) КАК Отклонение
	      |ПОМЕСТИТЬ ОтклоненияПоКоду
	      |ИЗ
	      |	ОтклоненияПоПартиям КАК ОтклоненияПоПартиям
	      |
	      |СГРУППИРОВАТЬ ПО
	      |	ОтклоненияПоПартиям.КодТовара366
	      |;
	      |
	      |////////////////////////////////////////////////////////////////////////////////
	      |ВЫБРАТЬ
	      |	Выборка.КодТовара366,
	      |	МИНИМУМ(Выборка.ЦенаРознНовая) КАК ЦенаРознНоваяМин,
	      |	МАКСИМУМ(Выборка.ЦенаРознНовая) КАК ЦенаРознНоваяМакс
	      |ПОМЕСТИТЬ ЦеныМинМакс
	      |ИЗ
	      |	ОтклоненияПоПартиям КАК Выборка
	      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтклоненияПоКоду КАК ОтклоненияПоКоду
	      |		ПО (ОтклоненияПоКоду.КодТовара366 = Выборка.КодТовара366)
	      |			И (ОтклоненияПоКоду.Отклонение = ЛОЖЬ)
	      |ГДЕ
	      |	Выборка.Отклонение = ЛОЖЬ
	      |
	      |СГРУППИРОВАТЬ ПО
	      |	Выборка.КодТовара366
	      |;
	      |
	      |////////////////////////////////////////////////////////////////////////////////
	      |ВЫБРАТЬ
	      |	Док.Партия,
	      |	Док.ЦенаРознНовая,
	      |	Док.ПредыдущаяЦена,
	      |	ВЫБОР
	      |		КОГДА ЕСТЬNULL(ОтклоненияПоКоду.Отклонение, ИСТИНА) = ЛОЖЬ
	      |			ТОГДА ВЫБОР
	      |					КОГДА Док.ЖНВЛС = ИСТИНА
	      |						ТОГДА ЕСТЬNULL(ЦеныМинМакс.ЦенаРознНоваяМин, 0)
	      |					ИНАЧЕ ЕСТЬNULL(ЦеныМинМакс.ЦенаРознНоваяМакс, 0)
	      |				КОНЕЦ
	      |		ИНАЧЕ 0
	      |	КОНЕЦ КАК ЦенаПубликации,
	      |	ОтклоненияПоПартии.Отклонение
	      |ИЗ
	      |	Документ.Перерасценка366.Товар КАК Док
	      |		ЛЕВОЕ СОЕДИНЕНИЕ ЦеныМинМакс КАК ЦеныМинМакс
	      |		ПО (ЦеныМинМакс.КодТовара366 = Док.КодТовара366)
	      |		ЛЕВОЕ СОЕДИНЕНИЕ ОтклоненияПоПартиям КАК ОтклоненияПоПартии
	      |		ПО (ОтклоненияПоПартии.Партия = Док.Партия)
	      |		ЛЕВОЕ СОЕДИНЕНИЕ ОтклоненияПоКоду КАК ОтклоненияПоКоду
	      |		ПО (ОтклоненияПоКоду.КодТовара366 = Док.КодТовара366)
	      |ГДЕ
	      |	Док.Ссылка = &Ссылка
	      |;
	      |
	      |////////////////////////////////////////////////////////////////////////////////
	      |УНИЧТОЖИТЬ ОтклоненияПоПартиям
	      |;
	      |
	      |////////////////////////////////////////////////////////////////////////////////
	      |УНИЧТОЖИТЬ ОтклоненияПоКоду
	      |;
	      |
	      |////////////////////////////////////////////////////////////////////////////////
	      |УНИЧТОЖИТЬ ЦеныМинМакс";
		  
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.Текст = ТХТ;
	ТЗ = Запрос.Выполнить().Выгрузить();
	Для каждого стр из ТЗ Цикл
		СтрокаТЧ  = Товар.Найти(стр.Партия,"Партия");
		Если НЕ СтрокаТЧ = Неопределено Тогда
			СтрокаТЧ.ЦенаПубликации = стр.ЦенаПубликации;
			СтрокаТЧ.Отклонение = стр.Отклонение;
			Если СтрокаТЧ.ЦенаПубликации > 0 Тогда
				СтрокаТЧ.Публикация = Истина;
			КонецЕсли;
	    КонецЕсли;
	КонецЦикла;
	
	ЭтотОбъект.Записать();
	
КонецПроцедуры
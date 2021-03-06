﻿
Перем мРегламентноеЗадание;


Процедура ОбновитьИнформациюВРегистреТоварныхОтчетов(НачалоПериода,КонецПериода,НайденнаяАптека,ЕстьОшибки,ДопИнформация)
	
	//Выборка = ПолучитьДанныеЗапретаПоАптеке(НайденнаяАптека);	
	
	
		
		МенеджерЗаписи = РегистрыСведений.ТоварныеОтчеты.СоздатьМенеджерЗаписи();
		
		// указываем параметр, по которому определяем, где будем позиционираваться (если одно измерение)
		МенеджерЗаписи.Аптека = НайденнаяАптека ;
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Выбран() Тогда // убедились, что спозиционироваться удалось
			
			Если  МенеджерЗаписи.КонПериода <= КонецПериода Тогда
				
				МенеджерЗаписи.НачПериода = НачалоПериода;
				МенеджерЗаписи.КонПериода = КонецПериода;	
				МенеджерЗаписи.ДатаСверки = ТекущаяДата();
				МенеджерЗаписи.НаличиеРасхождений = ЕстьОшибки;
				Если ЕстьОшибки = Ложь Тогда
					МенеджерЗаписи.ДатаЗакрытия = КонецПериода;
					МенеджерЗаписи.ДопИнформация = Новый ХранилищеЗначения(Неопределено);
				Иначе
					МенеджерЗаписи.ДопИнформация = Новый ХранилищеЗначения(ДопИнформация, Новый СжатиеДанных(9));
				КонецЕсли;
				
				МенеджерЗаписи.Записать();
				
			КонецЕсли;
			
		Иначе // спозиционироваться не удалось, можно выходить
			
			МенеджерЗаписи.Аптека = НайденнаяАптека ;
			МенеджерЗаписи.НачПериода = НачалоПериода;
			МенеджерЗаписи.КонПериода = КонецПериода;
			МенеджерЗаписи.ДатаСверки = ТекущаяДата();
			МенеджерЗаписи.НаличиеРасхождений = ЕстьОшибки;
			Если ЕстьОшибки = Ложь Тогда
				МенеджерЗаписи.ДатаЗакрытия = КонецПериода;
				МенеджерЗаписи.ДопИнформация = Новый ХранилищеЗначения(Неопределено);
			Иначе
				МенеджерЗаписи.ДопИнформация = Новый ХранилищеЗначения(ДопИнформация, Новый СжатиеДанных(9));
			КонецЕсли;
			МенеджерЗаписи.Записать();
			
		КонецЕсли;			
		
	
	
	
	
КонецПроцедуры

Процедура Загрузка() Экспорт
	
	Слэш = "\";
	Инфо = Новый СистемнаяИнформация;
	Если Инфо.ТипПлатформы = ТипПлатформы.Linux_x86 или 
		Инфо.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда	
		Путь = Константы.КаталогФТП.Получить() + "/out";
		ПутьБэкапа = Путь + "/sgr_BackUp";
		Слэш = "/";
	Иначе	
		Путь = Константы.КаталогФТП.Получить() + "\out";
		ПутьБэкапа = Путь + "\sgr_BackUp";
	КонецЕсли;
	
	
	
	Ф = Новый Файл(ПутьБэкапа);
	Если НЕ Ф.Существует() Тогда
		Попытка
			СоздатьКаталог(ПутьБэкапа);
		Исключение
			МодульРегламентныхЗаданий.ДобавитьЗаписьВЛог(мРегламентноеЗадание, Перечисления.ТипыЗаписейЛога.Информация, "Не удалось создать каталог архива." + Символы.ПС + ОписаниеОшибки());
		КонецПопытки;	
	КонецЕсли; 	 
	
	Файлы = НайтиФайлы(Путь, "sgr*.zip"); //массив файлов
	
	СписокФайловДляОбработки = Новый СписокЗначений;
	
	Для каждого Файло Из Файлы Цикл
		
		СписокФайловДляОбработки.Добавить(Файло.ПолноеИмя, Файло.Имя);
		
	КонецЦикла;
	
	ПараметрыЛога = Новый Соответствие;
	
	Для каждого Файло Из СписокФайловДляОбработки Цикл
		
		#Если Клиент Тогда
			ОбработкаПрерыванияПользователя();
		#КонецЕсли	
		
		ПараметрыЛога.Вставить("Файл", Файло.Значение);
		
		Попытка
			КопироватьФайл(Файло.Значение, ПутьБэкапа + Слэш + Файло.Представление);
		Исключение
			МодульРегламентныхЗаданий.ДобавитьЗаписьВЛог(мРегламентноеЗадание, Перечисления.ТипыЗаписейЛога.Информация, "Не удалось поместить файл в архив." + Символы.ПС + ОписаниеОшибки(), ПараметрыЛога);
		КонецПопытки;
		
		ОбработкаФайла(Файло, ПараметрыЛога,Слэш);
		
	КонецЦикла;	
	//МодульРегламентныхЗаданий.ДобавитьЗаписьВЛог(мРегламентноеЗадание, Перечисления.ТипыЗаписейЛога.Информация, "Проверка сработала." + Символы.ПС + "...");
КонецПроцедуры

Процедура ОбработкаФайла(ОбрФ, ПараметрыЛога,Слэш)  
	//----------------------------------
	//Назначение:
	//  Обрабатывает один файл выручки
	//  1) распаковывает
	//  2) обрабатывает
	//  3) перемещает архив в быкап, а временный файл затирает(?)
	//----------------------------------
	
	
	
	КодАптеки = Сред(ОбрФ.Представление,4,Найти(ОбрФ.Представление,"_")-1-3);
	
	НайденнаяАптека = Справочники.МестаХранения.НайтиПоКоду(ОбщегоНазначения.ПривестиСтрокуКЧислу(КодАптеки));
	Если НайденнаяАптека.Пустая() Тогда
		МодульРегламентныхЗаданий.ДобавитьЗаписьВЛог(мРегламентноеЗадание, Перечисления.ТипыЗаписейЛога.Ошибка, "Не найдена аптека с кодом: " + КодАптеки, ПараметрыЛога);
		Возврат;
	КонецЕсли;	
	
	
	ПИФ=ОбрФ.Значение; // полное имя файла
	
	//==================<Распакуем>===================GtG====14.01.2008
	ДБФФайл=ОМ17_РаспаковатьФайлВоВременныйКаталогИПереименоватьЕго(ПИФ,"sgr_tmp.DBF");
	
	//==================<Считываем ДБФ в таблицу значений>===================GtG====14.01.2008
	ДБФ = Новый  XBase;
	
	
	//==================<Сразу Отсеиваем пустые файлы>===================GtG====18.01.2008
	
	Попытка // битые файлы могут быть
		ДБФ.ОткрытьФайл(ДБФФайл);
		
		Если ДБФ.КоличествоЗаписей()=0 Тогда
			УдалитьФайлы(ОбрФ.Значение);
			Возврат;
		КонецЕсли; 	
		
	ИСключение //(Битый файл) запросить у аптеки новую выгрузку файла
		ПроблемныйПИФ=СтрЗаменить(ВРег(Пиф),"SGR","S_G_R(битый)");
		МодульРегламентныхЗаданий.ДобавитьЗаписьВЛог(мРегламентноеЗадание, Перечисления.ТипыЗаписейЛога.Ошибка, ""+СокрЛП(ДБФФайл)+"" + Символы.ПС + "" + ОписаниеОшибки(), ПараметрыЛога);
		Попытка
			ПереместитьФайл(ПИФ,ПроблемныйПИФ);
		Исключение
			//Сообщить("Не удалось переместить "+ Пиф);
		КонецПопытки;
		Возврат;
	КонецПопытки; 	
	
	ЕстьОшибки = Ложь;
	
	ДБФ.Перейти(1);
	НачалоПериода = ДБФ.DBEGIN;
	КонецПериода = ДБФ.DEND;
	
	ДопИнформация = "Период сверки с " + Формат(НачалоПериода,"ДФ=dd.MM.yyyy") + " по " + Формат(КонецПериода,"ДФ=dd.MM.yyyy") + "";
	
	ТипыДокументов = Новый Соответствие;
	ТипыДокументов.Вставить(1,"ПеремещениеТМЦ");
	ТипыДокументов.Вставить(3,"ВводОстатков");
	ТипыДокументов.Вставить(7,"ВозвратНаСклад");
	ТипыДокументов.Вставить(14,"Инвентаризация");
	ТипыДокументов.Вставить(17,"МежскладскаяПередача (расход)");
	ТипыДокументов.Вставить(19,"Переоценка");
	ТипыДокументов.Вставить(20,"Списание");	
	ТипыДокументов.Вставить(23,"МежскладскаяПередача (приход)");
	ТипыДокументов.Вставить(27,"ПоступлениеТовара");
	ТипыДокументов.Вставить(28,"Возврат От Покупателя");
	ТипыДокументов.Вставить(29,"Возврат товара поставщику");
	ТипыДокументов.Вставить(30,"РеализацияОптом");
	ТипыДокументов.Вставить(31,"Корректировка инвентаризации");
	ТипыДокументов.Вставить(1000,"РеализацияККМ");
	
	ТХТ = "ВЫБРАТЬ
	      |	РегОбороты.Регистратор КАК Документ,
	      |	ВЫБОР
	      |		КОГДА РегОбороты.СуммаРознСНДСОборот < 0
	      |			ТОГДА -1 * РегОбороты.СуммаРознСНДСОборот
	      |		ИНАЧЕ РегОбороты.СуммаРознСНДСОборот
	      |	КОНЕЦ КАК Сумма,
	      |	ВЫБОР
	      |		КОГДА РегОбороты.СуммаРознСНДСОборот < 0
	      |			ТОГДА 1
	      |		ИНАЧЕ 0
	      |	КОНЕЦ КАК ПриходРасход,
	      |	НАЧАЛОПЕРИОДА(РегОбороты.Период, ДЕНЬ) КАК Период,
	      |	ВЫБОР
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.Переоценка
	      |			ТОГДА РегОбороты.Регистратор.НомерДокументаАптеки
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.РеализацияККМ
	      |			ТОГДА """"
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.ПоступлениеТовара
	      |			ТОГДА РегОбороты.Регистратор.Номер
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.ВводОстатков
	      |			ТОГДА РегОбороты.Регистратор.Номер
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.ПеремещениеТовара
	      |			ТОГДА ВЫБОР
	      |					КОГДА РегОбороты.СуммаРознСНДСОборот < 0
	      |						ТОГДА РегОбороты.Регистратор.НомДокАптеки
	      |					ИНАЧЕ РегОбороты.Регистратор.Номер
	      |				КОНЕЦ
	      |		ИНАЧЕ РегОбороты.Регистратор.НомДокАптеки
	      |	КОНЕЦ КАК НомерДокАптеки,
	      |	ВЫБОР
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.Переоценка
	      |			ТОГДА 19
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.РеализацияККМ
	      |			ТОГДА 1000
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.ПоступлениеТовара
	      |			ТОГДА 27
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.ВводОстатков
	      |			ТОГДА 3
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.РеализацияОптом
	      |			ТОГДА 30
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.ВозвратОтПокупателя
	      |			ТОГДА 28
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.Инвентаризация
	      |			ТОГДА 14
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.ВозвратТовараПоставщику
	      |			ТОГДА 29
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.Списание
	      |			ТОГДА 20
	      |		КОГДА РегОбороты.Регистратор ССЫЛКА Документ.ПеремещениеТовара
	      |			ТОГДА ВЫБОР
	      |					КОГДА РегОбороты.Регистратор.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОпераций.МежскладскаяПередача)
	      |						ТОГДА ВЫБОР
	      |								КОГДА РегОбороты.СуммаРознСНДСОборот > 0
	      |									ТОГДА 23
	      |								ИНАЧЕ 17
	      |							КОНЕЦ
	      |					КОГДА РегОбороты.Регистратор.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОпераций.ПеремещениеТМЦ)
	      |						ТОГДА 1
	      |					КОГДА РегОбороты.Регистратор.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОпераций.ВозвратНаСклад)
	      |						ТОГДА 7
	      |				КОНЕЦ
	      |		ИНАЧЕ 0
	      |	КОНЕЦ КАК Тип
	      |ИЗ
	      |	РегистрНакопления.ОстаткиПоСтНДСПоСкладам.Обороты(
	      |			&НачПериода,
	      |			&КонПериода,
	      |			Регистратор,
	      |			Склад = &Склад
	      |				И Фирма = &Фирма) КАК РегОбороты
	      |ГДЕ
	      |	(РегОбороты.Регистратор ССЫЛКА Документ.РеализацияККМ
	      |			ИЛИ РегОбороты.Регистратор ССЫЛКА Документ.ПоступлениеТовара
	      |			ИЛИ РегОбороты.Регистратор ССЫЛКА Документ.ПеремещениеТовара
	      |			ИЛИ РегОбороты.Регистратор ССЫЛКА Документ.ВозвратТовараПоставщику
	      |			ИЛИ РегОбороты.Регистратор ССЫЛКА Документ.ВозвратОтПокупателя
	      |			ИЛИ РегОбороты.Регистратор ССЫЛКА Документ.Списание
	      |			ИЛИ РегОбороты.Регистратор ССЫЛКА Документ.РеализацияОптом
	      |			ИЛИ РегОбороты.Регистратор ССЫЛКА Документ.Переоценка
	      |			ИЛИ РегОбороты.Регистратор ССЫЛКА Документ.ВводОстатков
	      |			ИЛИ РегОбороты.Регистратор ССЫЛКА Документ.Инвентаризация)
	      |
	      |ОБЪЕДИНИТЬ ВСЕ
	      |
	      |ВЫБРАТЬ
	      |	Переоценка.Ссылка,
	      |	0,
	      |	0,
	      |	НАЧАЛОПЕРИОДА(Переоценка.Дата, ДЕНЬ),
	      |	Переоценка.НомерДокументаАптеки,
	      |	19
	      |ИЗ
	      |	Документ.Переоценка КАК Переоценка
	      |ГДЕ
	      |	Переоценка.Дата МЕЖДУ &НачПериода И &КонПериода
	      |	И Переоценка.Склад = &Склад
	      |	И Переоценка.ДельтаПереоценки = 0
	      |	И Переоценка.ПометкаУдаления = ЛОЖЬ
	      |
	      |ОБЪЕДИНИТЬ ВСЕ
	      |
	      |ВЫБРАТЬ
	      |	Поступление.Ссылка,
	      |	0,
	      |	0,
	      |	НАЧАЛОПЕРИОДА(Поступление.Дата, ДЕНЬ),
	      |	Поступление.Номер,
	      |	27
	      |ИЗ
	      |	Документ.ПоступлениеТовара КАК Поступление
	      |ГДЕ
	      |	Поступление.Дата МЕЖДУ &НачПериода И &КонПериода
	      |	И Поступление.Склад = &Склад
	      |	И Поступление.СуммаДокРозн = 0
	      |	И Поступление.ПометкаУдаления = ЛОЖЬ";
	
	Запрос =Новый Запрос(ТХТ);

	
	Запрос.УстановитьПараметр("НачПериода",НачалоДня(НачалоПериода));
	Запрос.УстановитьПараметр("КонПериода",КонецДня(КонецДня(КонецПериода)));
	Запрос.УстановитьПараметр("Фирма",НайденнаяАптека.Фирма);
	Запрос.УстановитьПараметр("Склад",НайденнаяАптека);
	
	Результат=Запрос.Выполнить().Выгрузить();
    //Результат.ВыбратьСтроку();
	
	ТЗИтог = Новый ТаблицаЗначений;
	ТЗИтог.Колонки.Добавить("Дата");
	ТЗИтог.Колонки.Добавить("Тип");
	ТЗИтог.Колонки.Добавить("Сумма");
	ТЗИтог.Колонки.Добавить("Номер");
	ТЗИтог.Колонки.Добавить("Признак");
	ТЗИтог.Колонки.Добавить("ТипОплаты");
	
	
	Для каждого стр Из Результат Цикл
		
		//Гемороим с Реализацией и типом оплаты
		Если ТипЗнч(стр.Документ)  = ТипЗнч(Документы.РеализацияККМ.ПустаяСсылка()) Тогда
			
			ТЗПродажи = стр.Документ.Бухгалтерия.Выгрузить();
			ТЗПродажи.Свернуть("ТипОплаты","СуммаБезСкидки,СуммаСкидки");
			
		КонецЕсли;
		
		
		Если стр.Тип = 1000 Тогда
			Для каждого н Из ТЗПродажи Цикл
				текСтр = ТЗИтог.Добавить();
				текСтр.Тип	= стр.Тип;
				текСтр.Дата = стр.Период; 
				текСтр.Номер = Строка(СокрЛП(Формат(стр.НомерДокАптеки,"ЧГ=0")));
				текСтр.Сумма = н.СуммаБезСкидки;
				Если стр.Документ.Затычка = Истина Тогда
					текСтр.Признак = 2;	
				Иначе
					текСтр.Признак = -1;
				КонецЕсли;
				Если н.ТипОплаты = Перечисления.ТипыОплаты.Наличными Тогда 
					текСтр.ТипОплаты = 1;
				Иначе
					текСтр.ТипОплаты = 3;
			    КонецЕсли;
			КонецЦикла; 		
		Иначе
			текСтр = ТЗИтог.Добавить();
			текСтр.Дата = стр.Период;  
			текСтр.Тип	= стр.Тип;
			текСтр.Номер = Строка(СокрЛП(Формат(стр.НомерДокАптеки,"ЧГ=0")));
			текСтр.Сумма = стр.Сумма;
			текСтр.ТипОплаты = -1;
			текСтр.Признак = -1;
		КонецЕсли;
		
	КонецЦикла; 	
	
	
	кз = ДБФ.КоличествоЗаписей();
	
	СтруктураПоиска = Новый Структура;
	ТЗДБФ = Новый ТаблицаЗначений;
	ТЗДБФ.Колонки.Добавить("Дата");
	ТЗДБФ.Колонки.Добавить("Тип");
	ТЗДБФ.Колонки.Добавить("Сумма");
	ТЗДБФ.Колонки.Добавить("Номер");
	ТЗДБФ.Колонки.Добавить("Признак");
	ТЗДБФ.Колонки.Добавить("ТипОплаты");
	
	ТЗСерт = Новый ТаблицаЗначений;
	ТЗСерт.Колонки.Добавить("Дата");
	ТЗСерт.Колонки.Добавить("Сумма");
	ТЗСерт.Колонки.Добавить("ТипОплаты");	
	
	Для н = 1 по кз Цикл
		ДБФ.Перейти(н);	
		Дата = НачалоДня(ДБФ.DDOC);    // Формат(ДБФ.DDOC,"ДФ=dd.MM.yyyy");
		Номер = ДБФ.NDOC;
		Сумма = ДБФ.SUMR;
		Тип = ДБФ.DOCTYPE;
		Скидка = ДБФ.ISSK;
		Если Тип = 28 Тогда //Если возврат от покупателя
			ТипОплаты = -1;	
		Иначе
			ТипОплаты = ДБФ.PAYTYPE;
		КонецЕсли;
		Если Скидка = 1 Тогда
			ДБФ.ISCENTRAL = 1;
			ДБФ.Записать();			
			Продолжить;
		КонецЕсли;
		
		Стр = ТЗДБФ.Добавить();
		Стр.Дата = Дата;
		Стр.Тип	 = Тип;
		Стр.Номер = СокрЛП(Номер);
		Стр.Сумма = Сумма;
		Стр.Признак = 1;
		Если (Тип = 1000) Тогда
			Если ТипОплаты = 5 Тогда
				стрСерт = ТЗСерт.Добавить();
				стрСерт.Дата = Дата;
				стрСерт.ТипОплаты = ТипОплаты;
				стрСерт.Сумма = Сумма;
				
				ТипОплаты = 1;
				ДБФ.ISCENTRAL = 1;
				ДБФ.Записать();
			ИначеЕсли ТипОплаты = 6 Тогда
				стрСерт = ТЗСерт.Добавить();
				стрСерт.Дата = Дата;
				стрСерт.ТипОплаты = ТипОплаты;
				стрСерт.Сумма = Сумма;
				
				ТипОплаты = 3;
				ДБФ.ISCENTRAL = 1;
				ДБФ.Записать();
			Иначе
				ТипОплаты = ТипОплаты;
			КонецЕсли;
		КонецЕсли;
		
		Стр.ТипОплаты = ТипОплаты;
		
	КонецЦикла;
	
	ТЗДБФ.Свернуть("Дата,Тип,Номер,Признак,ТипОплаты","Сумма");
	НомерСтроки = 0;	
	Для н = 1 по кз Цикл
		НомерСтроки = НомерСтроки + 1;
		ДБФ.Перейти(н);
		Дата = НачалоДня(ДБФ.DDOC);    // Формат(ДБФ.DDOC,"ДФ=dd.MM.yyyy");
		Номер = ДБФ.NDOC;
		Сумма = ДБФ.SUMR;
		Тип = ДБФ.DOCTYPE;
		Скидка = ДБФ.ISSK;
		Если Тип = 28 Тогда //Если возврат от покупателя
			ТипОплаты = -1;	
		Иначе
			ТипОплаты = ДБФ.PAYTYPE;
		КонецЕсли;
		Если Скидка = 1 Тогда
			ДБФ.ISCENTRAL = 1;
			ДБФ.Записать();			
			Продолжить;
		КонецЕсли;
		
		//  =====================================================================
		//  ====================  ПЕРВЫЙ ЗАХОД:ИЩЕМ ПО ТАБЛИЦЕ 1С ===============
		//  =====================================================================
		СуммаСерт = 0;
		Если Тип = 1000 Тогда
			СтруктураПоиска.Очистить();
			СтруктураПоиска.Вставить("Дата",Дата);
			//СтруктураПоиска.Вставить("Номер",СокрЛП(Номер));
			СтруктураПоиска.Вставить("ТипОплаты",ТипОплаты);
			ТипОплатыДБФ = ДБФ.PAYTYPE;
			Если ТипОплаты = 1 Тогда
				  ТипОплатыДБФ  = 5;
			ИначеЕсли ТипОплаты = 3 Тогда
				  ТипОплатыДБФ = 6;
			Иначе
				  Продолжить;
			КонецЕсли;
			//Если ТипОплатыДБФ  = 5 или ТипОплатыДБФ = 6 Тогда
				СтруктураДБФ = Новый Структура;
				СтруктураДБФ.Вставить("Дата",Дата);
				СтруктураДБФ.Вставить("ТипОплаты",ТипОплатыДБФ);
				Строки = ТЗСерт.НайтиСтроки(СтруктураДБФ);
		        
				Если Строки.Количество() > 0 Тогда
					СуммаСерт = Строки.Получить(0).Сумма;
            	КонецЕсли;

		Иначе
			СтруктураПоиска.Очистить();
			СтруктураПоиска.Вставить("Тип",Тип);
			СтруктураПоиска.Вставить("Номер",СокрЛП(Номер));
			СтруктураПоиска.Вставить("ТипОплаты",ТипОплаты);
		КонецЕсли;
		
		СтрокиПоиска = ТЗИтог.НайтиСтроки(СтруктураПоиска);
		
		Если СтрокиПоиска.Количество() > 0 Тогда
			Если  СтрокиПоиска.Получить(0).Признак = 2 Тогда //Специально по просьбе Жигульского 
				ДБФ.SumFail = 1; 	
				ДБФ.SCENTRAL = -1;
				ЕстьОшибки = Истина;
				ДопИнформация = ДопИнформация + Символы.ПС + "Проблема с выручкой за " + Дата;
			Иначе
				Сумма1С = СтрокиПоиска.Получить(0).Сумма - СуммаСерт;
				Дата1С = СтрокиПоиска.Получить(0).Дата;
				Если Сумма1С <> Сумма Тогда
					ДБФ.SumFail = 1; 
					ДБФ.SCENTRAL = Сумма1С;
					ЕстьОшибки = Истина;
					ДопИнформация = ДопИнформация + Символы.ПС + "" + ТипыДокументов[Тип] + " № " + СокрЛП(Номер) + " от " + Формат(Дата,"ДФ=dd.MM.yyyy") + " : разница сумм ( 1С = " + Сумма1С + " Аптека = "+Сумма + ")";
				КонецЕсли;
				Если Дата1С <> Дата Тогда
					ДБФ.DateFail = 1; 
					ДБФ.DCENTRAL = Дата1С;
					ЕстьОшибки = Истина;
					ДопИнформация = ДопИнформация + Символы.ПС + "" + ТипыДокументов[Тип] + " № " + СокрЛП(Номер) + " от " + Формат(Дата,"ДФ=dd.MM.yyyy") + " : разница дат ( 1С = " + Дата1С + " Аптека = "+Дата + ")";

				КонецЕсли;
			КонецЕсли;
			ДБФ.ISCENTRAL = 1;
			ДБФ.Записать();
		Иначе
			ЕстьОшибки=Истина;
			ДопИнформация = ДопИнформация + Символы.ПС + "" + ТипыДокументов[Тип] + " № " + СокрЛП(Номер) + " от " + Формат(Дата,"ДФ=dd.MM.yyyy") + " : нет документа в офисе. Сумма = " + Сумма + "";
		КонецЕсли;
		
		
  	КонецЦИкла;

	
	//  =====================================================================
	//  ====================  ВТОРОЙ ЗАХОД:ИЩЕМ ПО ТАБЛИЦЕ ДБФ ==============
	//  =====================================================================	
	Для каждого текСтр из ТЗИтог Цикл
		СтруктураПоиска.Очистить();
		СтруктураПоиска.Вставить("Тип",текСтр.Тип);
		СтруктураПоиска.Вставить("Номер",СокрЛП(текСтр.Номер));
		
		СтрокиПоиска = ТЗДБФ.НайтиСтроки(СтруктураПоиска);
		Если СтрокиПоиска.Количество() = 0 Тогда
			ДБФ.Добавить();
			ДБФ.NDOC = СокрЛП(текСтр.Номер);
			ДатаСтр	 = текСтр.Дата;
			ДБФ.DDOC = Дата(Сред(ДатаСтр,7,4),Сред(ДатаСтр,4,2),Сред(ДатаСтр,1,2));			
			ДБФ.DOCTYPE = текСтр.Тип;
			ДБФ.SUMR = текСтр.Сумма;
			ДБФ.ISSUBUNIT = 0;
			ДБФ.ISCENTRAL = 1;
			ДБФ.Записать();
			ЕстьОшибки = Истина;
		КонецЕсли;

	КонецЦикла;
	

	
	Если ЕстьОшибки = Ложь Тогда
		ДопИнформация = "";
	КонецЕсли;
	
	ОбновитьИнформациюВРегистреТоварныхОтчетов(НачалоПериода,КонецПериода,НайденнаяАптека,ЕстьОшибки,ДопИнформация);
	
	Попытка
		ДБФ.ЗакрытьФайл();
	Исключение
	КонецПопытки;	
	
	ИтоговыйФайл = Лев(ПИФ,СтрДлина(ПИФ)-3) + "dbf";
	Попытка
		ПереместитьФайл(ДБФФайл,ИтоговыйФайл);
	Исключение
		#Если Клиент Тогда
			Сообщить(ОписаниеОшибки());
		#КонецЕсли
	КонецПопытки;
	Архив = Архивация(ИтоговыйФайл);
	Попытка
		ПереместитьФайл(Архив.ПолноеИмя,НайденнаяАптека.КаталогОбмена + Слэш +Архив.Имя);
	Исключение
		#Если Клиент Тогда
			Сообщить(ОписаниеОшибки());
		#КонецЕсли
	КонецПопытки;
	
КонецПроцедуры	//ОбработкаФайлаВыручки

Функция Архивация(Файл)
	
	//Проверяем на наличие файла (на всяк случай ), потом геть его в архив, а dbf удаляем
	ВремФайл = Новый Файл(Файл);
	Если ВремФайл.Существует() Тогда
		ИмяАрхива = ВремФайл.Путь + "" + ВремФайл.ИмяБезРасширения + ".zip";
		ФайлАрхива = Новый ЗаписьZipФайла(ИмяАрхива, , , МетодСжатияZIP.Сжатие, УровеньСжатияZIP.Максимальный); 
		ФайлАрхива.Добавить(Файл, РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно); 
		ФайлАрхива.Записать();
		УдалитьФайлы(Файл);
	КонецЕсли;
	
	Возврат Новый Файл(ИмяАрхива);
	
КонецФункции

мРегламентноеЗадание = Справочники.РегламентныеЗадания.НайтиПоКоду("СверкаТоварныхОтчетов");
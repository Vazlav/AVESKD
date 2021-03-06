﻿Перем СтатусСписанияПриОткрытии Экспорт;

Функция КорректировкаСпецСимволов(Значение)
	
	//Возврат Значение;
	
   Результат = СтрЗаменить(Значение, "&", "&amp;");
   Результат = СтрЗаменить(Результат, "<", "&lt;");
   Результат = СтрЗаменить(Результат, ">", "&gt;");
   Результат = СтрЗаменить(Результат, """", "&quot;");
   Результат = СтрЗаменить(Результат, "'", "&apos;");
   Результат = СтрЗаменить(Результат, "/", "&#x2F;");	
   Возврат Результат;
   
КонецФункции

Процедура ЗаписатьЭлементXML(ЗаписьXML, Имя, Значение) 
	
	//ЗаписьXML.ЗаписатьНачалоЭлемента(Имя);
	//ЗаписьXML.ЗаписатьТекст(Значение);
	//ЗаписьXML.ЗаписатьКонецЭлемента();
	Если Значение = "" Тогда
		ЗаписьXML.ДобавитьСтроку("<" + Имя + "/>");
	Иначе
		ЗаписьXML.ДобавитьСтроку("<" + Имя + ">" + Значение + "</" + Имя + ">");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьНачалоЭлемента(ЗаписьXML,Имя)
	
	ЗаписьXML.ДобавитьСтроку("<" + Имя + ">");
	
КонецПроцедуры

Процедура ЗаписатьКонецЭлемента(ЗаписьXML,Имя)
	
	ЗаписьXML.ДобавитьСтроку("</" + Имя + ">");
	
КонецПроцедуры


Функция ВыгрузитьВАптеку() Экспорт

	Если СтатусСписания <> Перечисления.СтатусыСписания.Согласован и НЕ СтатусСписания = Перечисления.СтатусыСписания.Аннулирован Тогда //Самсонов ENT-217
		#Если Клиент Тогда
			Предупреждение("Документ непроведен. Выполнение не может быть продолжено");
		#КонецЕсли
		Возврат Ложь;
	КонецЕсли;
	
	ТХТ = "ВЫБРАТЬ
		      |	Списание.КодПартии КАК КодПартии,
		      |	Списание.КодПартииАптеки КАК КодПартииАптеки,
		      |	Списание.Количество * Списание.Коэфф КАК Количество,
		      |	Списание.Отказано * Списание.Коэфф КАК Отказано
		      |ИЗ
		      |	Документ.УЗ_Списание.Товар КАК Списание
		      |ГДЕ
		      |	Списание.Ссылка = &Ссылка";
			Запрос = Новый Запрос;
			Запрос.Текст = ТХТ;
			Запрос.УстановитьПараметр("Ссылка",Ссылка);
			
			Результат				= Запрос.Выполнить();	   
			ВыборкаСтроки			= Результат.Выбрать();
			
			

	ЗаписьXML = Новый ТекстовыйДокумент;
	
	
	ЗаписьXML.ДобавитьСтроку("<?xml version=""1.0"" encoding=""WINDOWS-1251""?>");

	ЗаписьXML.ДобавитьСтроку("<document>"); 

	
	ЗаписатьЭлементXML(ЗаписьXML, "pack_type", "OUT_WRITE_OFF"); 
	ЗаписатьЭлементXML(ЗаписьXML, "fmt_ver", "1"); 

		
		ЗаписьXML.ДобавитьСтроку("<hdr>");
			     ЗаписатьЭлементXML(ЗаписьXML, "id_doc_type", 	"212"); 
				 ЗаписатьЭлементXML(ЗаписьXML, "guid",	ИДДокументаАптеки); 
				 ЗаписатьЭлементXML(ЗаписьXML, "ddoc",	Формат(Дата,"ДФ=dd.MM.yyyy"));
				 Если СтатусСписания = Перечисления.СтатусыСписания.Аннулирован Тогда
				 	ЗаписатьЭлементXML(ЗаписьXML, "status",	Перечисления.СтатусДокАптеки.Индекс(Перечисления.СтатусДокАптеки.Аннулирован)); 
				 ИначеЕсли СтатусСписания = Перечисления.СтатусыСписания.Согласован Тогда
					ЗаписатьЭлементXML(ЗаписьXML, "status",	Перечисления.СтатусДокАптеки.Индекс(Перечисления.СтатусДокАптеки.ОбработанОфисом));  
				 Иначе
					ЗаписатьЭлементXML(ЗаписьXML, "status",	Перечисления.СтатусДокАптеки.Индекс(Перечисления.СтатусДокАптеки.Проведен)); 
				КонецЕсли;
		//Начало НЭТИ Барданов А.Ю. 19.02.2019 ENT-672 
		ЗаписатьЭлементXML(ЗаписьXML, "dsc_office", КомментарийОфиса);		
		//Конец НЭТИ Барданов А.Ю. 19.02.2019 ENT-672 
	  	ЗаписьXML.ДобавитьСтроку("</hdr>"); //конец записи секции  "hdr"
		
		ВыборкаСтроки.Сбросить();
		ЗаписьXML.ДобавитьСтроку("<str>");
		Пока ВыборкаСтроки.Следующий() Цикл
			ЗаписьXML.ДобавитьСтроку("<row>");
				ЗаписатьЭлементXML(ЗаписьXML, "guid_gpart"	,Формат(ВыборкаСтроки.КодПартии,"ЧГ=0; ЧН=0")); 
				ЗаписатьЭлементXML(ЗаписьXML, "id_gpart"		,Формат(ВыборкаСтроки.КодПартииАптеки,"ЧГ=0; ЧН=0")); 
				ЗаписатьЭлементXML(ЗаписьXML, "qnt"			,Формат(ВыборкаСтроки.Количество,"ЧГ=0; ЧН=0")); 
				//ЗаписатьЭлементXML(ЗаписьXML, "qnt_denied"			,Формат(ВыборкаСтроки.Отказано,"ЧГ=0; ЧН=0")); 
			ЗаписьXML.ДобавитьСтроку("</row>");
		КонецЦикла;
		ЗаписьXML.ДобавитьСтроку("</str>"); //конец записи секции  "str"
	
	ЗаписьXML.ДобавитьСтроку("</document>"); //конец записи секции  "document"
	ВесьТекст = ЗаписьXML.ПолучитьТекст();
	ЗаписьXML.Очистить();
	ЗаписьXML = Неопределено;
	
	КодСклада = Склад.Код;
	КодСчетчика = ОМ_ТСО.ПолучитьКодСчетчика("ОбменАптекаОфисЦелевые");
	Если КодСчетчика = -1 Тогда
		КодСчетчика = ОМ_ТСО.ПолучитьКодСчетчика("ОбменАптекаОфисЦелевые");
		Если КодСчетчика = -1 Тогда
			Возврат Ложь;	
		КонецЕсли;
	КонецЕсли;
	
	
	МЗ = РегистрыСведений.ОфисАптекаЦелевые.СоздатьМенеджерЗаписи();
	МЗ.Код = КодСчетчика;
	МЗ.КодАптеки = Склад.Код;
	МЗ.ТипУпаковки = "OUT_WRITE_OFF";
	МЗ.Приоритет = 1;
	МЗ.ВерсияФормата = 1;
	МЗ.ИмяФайла = "out_write_off_" + СокрЛП(Формат(КодСклада,"ЧГ=0")) + "_" + СокрЛП(Формат(Номер,"ЧГ=0")) + "_" + Формат(Дата,"ДФ=dd.MM.yyyy") +".xml";
	МЗ.ИдентификаторКодировки = 1;
	МЗ.ХМЛСтрока = ВесьТекст;
	МЗ.ИдентификаторДокумента = ИДДокументаАптеки;
	МЗ.Записать();	
	
	//Начало НЭТИ Барданов А.Ю. 17.01.2019 ENT-1140 
	ОбщегоНазначения.ЗаписатьИсториюИзмененияДокумента(Ссылка,"Выгружен",ПараметрыСеанса.ТекущийСотр,"Выгружен согласованный документ в аптеку");
	//Конец НЭТИ Барданов А.Ю. 17.01.2019 ENT-1140 	
	
	Возврат Истина;
	
	
КонецФункции

Процедура ПроверитьНаЗаполнение(Отказ)
	
	Если НЕ Согласован Тогда
		#Если Клиент Тогда
			Сообщить("Документ " + Ссылка + " не прошел согласование. Проведение отменено!",СтатусСообщения.ОченьВажное);	 
		#КонецЕсли	
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ВидОперацииСписания.Пустая() Тогда
		#Если Клиент Тогда
			Сообщить("Не указан вид операции возврата! Документ не проведен",СтатусСообщения.ОченьВажное);	 
		#КонецЕсли	
		Отказ = Истина;
		Возврат;
	Иначе
		Если ВидОперацииСписания = Перечисления.ВидыОперацийСписания.Недовоз или ВидОперацииСписания = Перечисления.ВидыОперацийСписания.Неопределено Тогда
			#Если Клиент Тогда
				Сообщить("Вид операции возврата не может быть <Недовоз> или <Неопределено>! Документ не проведен",СтатусСообщения.ОченьВажное);	 
			#КонецЕсли	
			Отказ = Истина;
			Возврат;
		КонецЕсли;			
	КонецЕсли;
	
	Если ПричинаСписания.Пустая() Тогда
		#Если Клиент Тогда
			Сообщить("Не указана причина списания! Документ не проведен",СтатусСообщения.ОченьВажное);	 
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
	
	
	Если ВидОперацииСписания = Перечисления.ВидыОперацийСписания.ОсновнойТовар или ВидОперацииСписания = Перечисления.ВидыОперацийСписания.Арбитражный Тогда
		КачествоТовараПорядок = Перечисления.УЗ_КачествоТовара.Индекс(Перечисления.УЗ_КачествоТовара.ХорошийТовар);
	ИначеЕсли ВидОперацииСписания = Перечисления.ВидыОперацийСписания.Брак Тогда
		КачествоТовараПорядок = Перечисления.УЗ_КачествоТовара.Индекс(Перечисления.УЗ_КачествоТовара.Брак);
	КонецЕсли;
	
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.УстановитьПараметр("Дата",Дата);
	Запрос.УстановитьПараметр("СкладКод",Склад.Код);
	Запрос.УстановитьПараметр("ФирмаКод",Фирма.Код);
	Запрос.УстановитьПараметр("Склад",Склад);
	Запрос.УстановитьПараметр("КачествоТовараПорядок",КачествоТовараПорядок);
	
	
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	&СкладКод КАК СкладКод,
	               |	&ФирмаКод КАК ФирмаКод,
	               |	Партии.ВидПоступления КАК ВидПоступленияПорядок,
	               |	ТЧТовар.КодПартии КАК ПартияКод,
	               |	ТЧТовар.КодТовара КАК ТоварКод,
	               |	ТЧТовар.Количество * ТЧТовар.Коэфф КАК Количество,
	               |	ТЧТовар.Коэфф,
	               |	Партии.СтавкаНДСЗакуп,
	               |	ТЧТовар.СтавкаНДС,
	               |	ТЧТовар.СуммаЗакупБезНДС
	               |ПОМЕСТИТЬ ВТТовары
	               |ИЗ
	               |	Документ.УЗ_Списание.Товар КАК ТЧТовар
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УЗ_Партии КАК Партии
	               |		ПО (Партии.Код = ТЧТовар.КодПартии)
	               |ГДЕ
	               |	ТЧТовар.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТТовары.СкладКод КАК СкладКод,
	               |	ВТТовары.ФирмаКод КАК ФирмаКод,
	               |	ВТТовары.ВидПоступленияПорядок КАК ВидПоступленияПорядок,
	               |	ВТТовары.ПартияКод,
	               |	ВТТовары.ТоварКод,
	               |	ВТТовары.СтавкаНДСЗакуп,
	               |	ВТТовары.СтавкаНДС,
	               |	СУММА(ВТТовары.СуммаЗакупБезНДС) КАК СуммаЗакупБезНДС,
	               |	СУММА(ВТТовары.Количество) КАК Количество,
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	               |	&Дата КАК Период
	               |ИЗ
	               |	ВТТовары КАК ВТТовары
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВТТовары.СкладКод,
	               |	ВТТовары.ФирмаКод,
	               |	ВТТовары.ВидПоступленияПорядок,
	               |	ВТТовары.ПартияКод,
	               |	ВТТовары.ТоварКод,
	               |	ВТТовары.СтавкаНДСЗакуп,
	               |	ВТТовары.СтавкаНДС
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТТовары.СкладКод,
	               |	ВТТовары.ФирмаКод,
	               |	&КачествоТовараПорядок КАК КачествоТовараПорядок,
	               |	ВТТовары.ВидПоступленияПорядок,
	               |	ВТТовары.СтавкаНДС КАК СтавкаНДС,
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
	               |	ВТТовары.СтавкаНДС
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТТовары";
				   
			Результат = Запрос.ВыполнитьПакет();	  
			
			Если ВидОперацииСписания = Перечисления.ВидыОперацийСписания.ОсновнойТовар Тогда 
				ТаблицыДвижений.Вставить("УЗ_Партии", Результат[1].Выгрузить());
			ИначеЕсли ВидОперацииСписания = Перечисления.ВидыОперацийСписания.Брак Тогда
				ТаблицыДвижений.Вставить("УЗ_ПартииБрак", Результат[1].Выгрузить());
			ИначеЕсли  ВидОперацииСписания = Перечисления.ВидыОперацийСписания.Арбитражный Тогда
				ТаблицыДвижений.Вставить("УЗ_ПартииАрбитраж", Результат[1].Выгрузить());
			КонецЕсли;
			
			ТаблицыДвижений.Вставить("УЗ_ТоварныйОтчет", Результат[2].Выгрузить());

				   
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим) Экспорт
	 
	 
	ТаблицыДвижений = Новый Структура();
	
	ПодготовитьТаблицыДвижений(ТаблицыДвижений);
	Движения.УЗ_Партии.Записывать = Истина;
	Движения.УЗ_ПартииБрак.Записывать = Истина;
	Движения.УЗ_ПартииАрбитраж.Записывать = Истина;
	
	Движения.УЗ_Партии.Очистить();
	Движения.УЗ_ПартииБрак.Очистить();
	Движения.УЗ_ПартииАрбитраж.Очистить();
	
	
	Если ВидОперацииСписания = Перечисления.ВидыОперацийСписания.ОсновнойТовар Тогда 
		Таблица= ТаблицыДвижений.УЗ_Партии;
		Движения.УЗ_Партии.Загрузить(Таблица);	
	ИначеЕсли ВидОперацииСписания = Перечисления.ВидыОперацийСписания.Брак Тогда
		Таблица= ТаблицыДвижений.УЗ_ПартииБрак;
		Движения.УЗ_ПартииБрак.Загрузить(Таблица);		
	ИначеЕсли  ВидОперацииСписания = Перечисления.ВидыОперацийСписания.Арбитражный Тогда
		Таблица= ТаблицыДвижений.УЗ_ПартииАрбитраж;
		Движения.УЗ_ПартииАрбитраж.Загрузить(Таблица);		
	КонецЕсли;
	
	Таблица= ТаблицыДвижений.УЗ_ТоварныйОтчет;
	Движения.УЗ_ТоварныйОтчет.Записывать = Истина;
	Движения.УЗ_ТоварныйОтчет.Загрузить(Таблица);
	
	ПоместитьВОбменСкладБух();  // GTG 02-04-2016

	// Отправить сообщение управляющему в случае, если это истечение срока годности и статус переведен в "Анулирован"
	Если ПричинаСписания = Перечисления.ПричиныСписания.СрокГодности Или 
		ПричинаСписания = Перечисления.ПричиныСписания.СрокГодностиМОЛ Или 
		ПричинаСписания = Перечисления.ПричиныСписания.ИстекСрокГодности Тогда
	
		Если (СтатусСписания = Перечисления.СтатусыСписания.СогласованиеОтменено ИЛИ
			СтатусСписания = Перечисления.СтатусыСписания.Аннулирован) И  
		     СтатусСписания <> СтатусСписанияПриОткрытии Тогда
			// Отправка сообщения
			АдресУА = "";
			Для каждого СтрокаТЧ Из Склад.Заведующие Цикл
			
				Если СтрокаТЧ.Должность = Перечисления.ДолжностиРуководителейАптек.УправляющийАптекой Тогда
				
					АдресУА = СтрокаТЧ.АдресЭлектроннойПочты;
					Прервать;
				
				КонецЕсли; 	
			
			КонецЦикла; 
			
			Если ЗначениеЗаполнено(АдресУА) Тогда
			
				Почта=Обработки.Почтарь.Создать();
				Почта.Автоотправка=Истина;
				Почта.Рассылка.Добавить(АдресУА);
					
				Почта.Тема = "Отмена согласования документа ""Списание товара"" в 1С Склад";
				Почта.ТекстПисьма = "Документ ""Списание товара"" № "+ Номер +" от " + Дата+" (причина списания: "+ПричинаСписания+"), № документа в аптеке "+НомДокАптеки+"  
				|в офисе установлен статус ""Согласование отменено""
				|Необходимо в течении двух рабочих дней поставить статус ""К обработке офисом"""; 
				
				Почта.функция_Послать()
			
			КонецЕсли; 
		
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатаПоследнегоИзменения = ТекущаяДата();
	
	Если НЕ ЭтоНовый() Тогда
		Если Год(Дата)>Год(Ссылка.Дата) Тогда
			УстановитьНовыйНомер();
		КонецЕсли; 			
	КонецЕсли;
	
	
	СуммаЗакупБезНДС = Товар.Итог("СуммаЗакупБезНДС");
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьНаЗаполнение(Отказ);	
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		СтатусСписания = Перечисления.СтатусыСписания.Проведен; //Самсонов ENT-217
				
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ОМ41_ПередУдалениемДокумента  (ЭтотОбъект,Отказ);
		Если Отказ = Истина Тогда
			Возврат;
		КонецЕсли;		
		
	КонецЕсли;
	
	ОбщегоНазначения.ЗаписатьСменуСостоянияДокумента(Ссылка,РежимЗаписи,ПометкаУдаления);
	
КонецПроцедуры


Процедура ПоместитьВОбменСкладБух() экспорт  // GTG 02-04-2016
	
	Запрос=Новый Запрос();
	Запрос.Текст="ВЫБРАТЬ
	             |	212 КАК ВидДокумента,
	             |	УЗ_Списание.Фирма.Код КАК КодФирмы,
	             |	""123456789012345678901234567890123456"" КАК СсылкаТХТ,
	             |	УЗ_Списание.Дата КАК ДатаОчередиСклад,
	             |	УЗ_Списание.Склад.Код КАК КодСклада,
	             |	0 КАК КодКонтрагента,
	             |	УЗ_Списание.Ссылка КАК Объект,
	             |	УЗ_Списание.Проведен КАК Проведен,
	             |	УЗ_Списание.ПометкаУдаления КАК ПомеченНаУдаление,
	             |	"""" КАК ОшибкаПриЗагрузке
	             |ИЗ
	             |	Документ.УЗ_Списание КАК УЗ_Списание
	             |ГДЕ
	             |	УЗ_Списание.Ссылка = &Ссылка";
	
	
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	Рез=Запрос.Выполнить();
	
	Если Рез.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выб=Рез.Выбрать();
	Выб.Следующий();
	
	
	МЗ=РегистрыСведений.ОбменСкладБух.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МЗ,Выб);
	
	Мз.СсылкаТХТ=МЗ.Объект.УникальныйИдентификатор();
	МЗ.Записать();
	
		
	
КонецПроцедуры	

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если РольДоступна("Техподдержка") = Истина Тогда
		#Если Клиент Тогда
			Предупреждение("Отмена проведения может привести к расхождениям между остатком офиса и аптеки!",5);
		#КонецЕсли
	ИначеЕсли СтатусСписания = Перечисления.СтатусыСписания.Проведен и Выгружен Тогда
		#Если Клиент Тогда
			Предупреждение("Распроведение выгруженного документа запрещено!",5);
		#КонецЕсли
		Отказ = истина;
	КонецЕсли;
	
КонецПроцедуры

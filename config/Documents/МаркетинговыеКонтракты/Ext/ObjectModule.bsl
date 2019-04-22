﻿
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




Процедура ПроверитьНаНаличиеТовараВДругихДокументах(Отказ)
	
	Построитель = Новый ПостроительОтчета;
	Построитель.Текст = "ВЫБРАТЬ
	                    |	ТЧВсе.Ссылка,
	                    |	ТЧВсе.НомерСтроки,
	                    |	ТЧВсе.КодТовара,
	                    |	ТЧВсе.Товар,
	                    |	ТЧВсе.СуммаБезусловногоБонусаЗаУпаковку,
	                    |	ТЧВсе.Отменена
	                    |ИЗ
	                    |	Документ.МаркетинговыеКонтракты.Товар КАК s
	                    |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаркетинговыеКонтракты КАК Ш
	                    |		ПО (Ш.Ссылка = s.Ссылка)
	                    |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаркетинговыеКонтракты.Товар КАК ТЧВсе
	                    |		ПО (ТЧВсе.КодТовара = s.КодТовара)
	                    |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаркетинговыеКонтракты КАК Ш2
	                    |		ПО (Ш2.Ссылка = ТЧВсе.Ссылка)
	                    |ГДЕ
	                    |	s.Ссылка = &Документ
	                    |	И ТЧВсе.Ссылка <> Ш.Ссылка
	                    |	И (Ш.НачалоПериода МЕЖДУ Ш2.НачалоПериода И Ш2.КонецПериода
	                    |			ИЛИ Ш.КонецПериода МЕЖДУ Ш2.НачалоПериода И Ш2.КонецПериода
	                    |			ИЛИ Ш2.НачалоПериода МЕЖДУ Ш.НачалоПериода И Ш.КонецПериода
	                    |			ИЛИ Ш2.КонецПериода МЕЖДУ Ш.НачалоПериода И Ш.КонецПериода)";
	Построитель.Параметры.Вставить("Документ",Ссылка);
	Построитель.Выполнить();
	Рез = Построитель.Результат;
	Если Рез.Пустой() Тогда
		Возврат;
	КонецЕсли;
	#Если Клиент Тогда
		Построитель.МакетОформления = ПолучитьМакетОформления(СтандартноеОформление.Трава);
		Построитель.Вывести();
		Предупреждение("В документе присутствуют позиции, которые содержатся в других документах");
	#КонецЕсли
	Отказ = Истина;
	
	
КонецПроцедуры

Процедура ПроверитьНаЗаполнение(Отказ)
	
	Если НачалоПериода = Дата(1,1,1) Тогда
		#Если Клиент Тогда
			Предупреждение("Не указана дата начала акции. Документ не может быть проведен",3);
		#КонецЕсли
		Отказ = Истина;	
	КонецЕсли;
	
	Если КонецПериода = Дата(1,1,1) Тогда
		#Если Клиент Тогда
			Предупреждение("Не указана дата окончании акции. Документ не может быть проведен",3);
		#КонецЕсли
		Отказ = Истина;	
	КонецЕсли;
	
	Если КонецПериода < НачалоПериода Тогда
		#Если Клиент Тогда
			Предупреждение("Неправильно указан период акции. Документ не может быть проведен",3);
		#КонецЕсли
		Отказ = Истина;				
	КонецЕсли;
	
	Если Производитель.Пустая() Тогда
		#Если Клиент Тогда
			Предупреждение("В документе не выбран производитель. Документ не может быть проведен",3);
		#КонецЕсли
		Отказ = Истина;	
	КонецЕсли;		
	
	Если НЕ Согласован Тогда
		#Если Клиент Тогда
			Предупреждение("Документ не прошел согласование. Проведение невозможно",3);
		#КонецЕсли
		Отказ = Истина;				
	КонецЕсли; 	
		
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатаИзменения = ТекущаяДата();
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 		
		//Если НЕ (РольДоступна("супер_АДМИНИСТРАТОР") или  РольДоступна("ОптовикиПолныеПрава")) Тогда		
		//	Предупреждение("Нет прав на проведение документа", 3);			
		//КонецЕсли; 		
		
		ПроверитьНаЗаполнение(Отказ);	
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ПроверитьНаНаличиеТовараВДругихДокументах(Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		Изменение = Изменения.Добавить();
		Изменение.Дата = ТекущаяДата();
		Изменение.КомментарийИзменения = "Создан новый документ";
		Изменение.Сотрудник = ПараметрыСеанса.ТекущийСотр;
		Изменение.ТипИзм = Перечисления.ДействияНадДокументами.ВводНового;
	КонецЕсли;
	
	ЗаписатьДействияВИсториюДокумента(Изменения,РежимЗаписи,ПометкаУдаления);	
	
КонецПроцедуры


Процедура ВыгрузитьВАптеки() Экспорт

	
	Если НЕ Проведен Тогда
		#Если Клиент Тогда
			Предупреждение("Документ непроведен. Выгрузка невозможна.");
		#КонецЕсли
		Возврат;
	КонецЕсли;	
	
	//Если Товар.Количество() = 0 Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//
	//  marketing_margin
	ЗаписьXML = Новый ТекстовыйДокумент;
	
	
	ЗаписьXML.ДобавитьСтроку("<?xml version=""1.0"" encoding=""WINDOWS-1251""?>");
	ЗаписьXML.ДобавитьСтроку("<document>"); 
	ЗаписатьЭлементXML(ЗаписьXML, "pack_type", "MARKETING_MARGIN"); 
	ЗаписатьЭлементXML(ЗаписьXML, "fmt_ver", "1"); 
	
	ЗаписьXML.ДобавитьСтроку("<hdr>");
		ЗаписатьЭлементXML(ЗаписьXML, "id",	Формат(Номер,"ЧГ=0; ЧН=0") );				
		ЗаписатьЭлементXML(ЗаписьXML, "start_dt",	Формат(НачалоПериода,"ДФ=dd.MM.yyyy") );				
		ЗаписатьЭлементXML(ЗаписьXML, "end_dt",		Формат(КонецПериода,"ДФ=dd.MM.yyyy") );				
	ЗаписьXML.ДобавитьСтроку("</hdr>");
	ЗаписьXML.ДобавитьСтроку("<str>");
	Для каждого стр из Товар Цикл
		
		
		
		Если стр.Отменена Тогда
			Продолжить;
		КонецЕсли;
		
		Если стр.ОтменаБУБ Тогда
			СуммаБонуса = стр.СуммаУсловногоБонусаЗаУпаковку;	
		Иначе
			СуммаБонуса = стр.СуммаУсловногоБонусаЗаУпаковку + стр.СуммаБезусловногоБонусаЗаУпаковку;	
		КонецЕсли;	
		
		Если СуммаБонуса = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаписьXML.ДобавитьСтроку("<row>");
			ЗаписатьЭлементXML(ЗаписьXML, "id_goods",	Формат(стр.КодТовара,"ЧГ=0") );	
			ЗаписатьЭлементXML(ЗаписьXML, "amount",		Формат(СуммаБонуса,"ЧРД=.; ЧН=0; ЧГ=0") );	
		ЗаписьXML.ДобавитьСтроку("</row>");
		
		
	КонецЦикла;
	ЗаписьXML.ДобавитьСтроку("</str>");
	
	
	ЗаписьXML.ДобавитьСтроку("</document>"); 
	
	ВесьТекст = ЗаписьXML.ПолучитьТекст();
	ЗаписьXML.Очистить();
	ЗаписьXML = Неопределено;
	
	
	
	КодСчетчика = ОМ_ТСО.ПолучитьКодСчетчика("ОбменАптекаОфисШВ");
	Если КодСчетчика = -1 Тогда
		КодСчетчика = ОМ_ТСО.ПолучитьКодСчетчика("ОбменАптекаОфисШВ");
		Если КодСчетчика = -1 Тогда
			Возврат;	
		КонецЕсли;
	КонецЕсли;
	
	МЗ = РегистрыСведений.ОфисАптекаШироковещание.СоздатьМенеджерЗаписи();
	МЗ.Код = КодСчетчика;
	МЗ.ТипУпаковки = "MARKETING_MARGIN";
	МЗ.Приоритет = 1;
	МЗ.ВерсияФормата = 1;
	МЗ.ИмяФайла = "marketing_margin_" + Формат(Номер,"ЧГ=0") +  "_" + Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy") +".xml";
	МЗ.ИдентификаторКодировки = 1;
	МЗ.ХМЛСтрока = ВесьТекст;
	МЗ.Записать();	
	
	
	Выгружен = истина;
	
	Изменение = Изменения.Добавить();
	Изменение.Дата = ТекущаяДата();
	Изменение.КомментарийИзменения = "Выгружен в аптеки";
	Изменение.Сотрудник = ПараметрыСеанса.ТекущийСотр;
	Изменение.ТипИзм = Перечисления.ДействияНадДокументами.Изменение;		
	Записать(РежимЗаписиДокумента.Запись);
	
	
	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	  Выгружен = Ложь;
	  Проведен = Ложь;
	  Согласован = Ложь;
	  СогласованКем = Справочники.Сотрудники.ПустаяСсылка();
	  Изменения.Очистить();
	
КонецПроцедуры

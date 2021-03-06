﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ДатаОтбора = Макс(ДобавитьМесяц(ТекущаяДата(), -3), Дата(2015,11,26));
	
	Если Дата >= ДатаОтбора Тогда
		
		Если ЗначениеЗаполнено(Получатель) Тогда //Реализация на склад Ориола
			ВыгрузитьДокументВЛичныйКабинет();	
			ОтправитьРаспоряжениеНаРеализацию();
			
		Иначе //Перемещение в другую аптеку
			ВыгрузитьДокументВЛичныйКабинет();
			ОтправитьРаспоряжениеНаПеремещение();
			
			НаборЗаписей = РегистрыСведений.СформированныеПечатныеФормы.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Документ.Установить(ЭтотОбъект.Ссылка);
			
			НоваяЗапись = НаборЗаписей.Добавить();	
			НоваяЗапись.Документ		= ЭтотОбъект.Ссылка;
			НоваяЗапись.Сформировать	= Истина;
			
			НаборЗаписей.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыгрузитьДокументВЛичныйКабинет()
	
	//ТСО {20.11.2015 #0054}
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РаспоряжениеНаПеремещениеТовар.Ссылка КАК Документ,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Номер КАК НомерДокумента,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Дата КАК ДатаДокумента,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Склад.Код КАК КодАптеки,
	|	ЕСТЬNULL(РаспоряжениеНаПеремещениеТовар.Ссылка.СкладПолучатель.Код, 0) КАК КодПолучателя,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Код КАК КодТовара,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Наименование КАК НаименованиеТовара,
	|	СУММА(РаспоряжениеНаПеремещениеТовар.Количество) КАК Количество,
	|	МАКСИМУМ(РаспоряжениеНаПеремещениеТовар.Товар.Холодильник) КАК Терм,
	|	СУММА(РаспоряжениеНаПеремещениеТовар.СуммаЗакуп) КАК СуммаЗакуп
	|ИЗ
	|	Документ.РаспоряжениеНаПеремещение.Товар КАК РаспоряжениеНаПеремещениеТовар
	|ГДЕ
	|	РаспоряжениеНаПеремещениеТовар.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	РаспоряжениеНаПеремещениеТовар.Ссылка,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Код,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Наименование,
	|	ЕСТЬNULL(РаспоряжениеНаПеремещениеТовар.Ссылка.СкладПолучатель.Код, 0),
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Номер,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Дата,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Склад.Код
	|ИТОГИ
	|	СУММА(Количество),
	|	МАКСИМУМ(Терм),
	|	СУММА(СуммаЗакуп)
	|ПО
	|	Документ";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДокумент = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаДокумент.Следующий() Цикл
		     		
		ИмяФайлаОтправки = ПолучитьИмяВременногоФайла("txt");
		
		Boundary = СтрЗаменить(Строка(Новый УникальныйИдентификатор()),"-","");
		
		ФайлОтправки = Новый ТекстовыйДокумент;
		ФайлОтправки.УстановитьТипФайла(КодировкаТекста.Системная);
		
		
		//ШАПКА
		ФайлОтправки.ДобавитьСтроку("--" + Boundary);
		ФайлОтправки.ДобавитьСтроку("Content-Disposition: form-data; name=""from_loc""" + Символы.ПС);
		ФайлОтправки.ДобавитьСтроку(Формат(ВыборкаДокумент.КодАптеки, "ЧДЦ=; ЧН=; ЧГ=0"));
		
		ФайлОтправки.ДобавитьСтроку("--" + Boundary);
		ФайлОтправки.ДобавитьСтроку("Content-Disposition: form-data; name=""to_loc""" + Символы.ПС);
		ФайлОтправки.ДобавитьСтроку(Формат(ВыборкаДокумент.КодПолучателя, "ЧДЦ=; ЧН=; ЧГ=0"));
		
		ФайлОтправки.ДобавитьСтроку("--" + Boundary);
		ФайлОтправки.ДобавитьСтроку("Content-Disposition: form-data; name=""doc_number""" + Символы.ПС);
		ФайлОтправки.ДобавитьСтроку(ВыборкаДокумент.НомерДокумента); 		
		
		ФайлОтправки.ДобавитьСтроку("--" + Boundary);
		ФайлОтправки.ДобавитьСтроку("Content-Disposition: form-data; name=""doc_date""" + Символы.ПС);
		ФайлОтправки.ДобавитьСтроку(Формат(ВыборкаДокумент.ДатаДокумента, "ДФ=yyyy-MM-dd"));
		
		ФайлОтправки.ДобавитьСтроку("--" + Boundary);
		ФайлОтправки.ДобавитьСтроку("Content-Disposition: form-data; name=""plan_packed_date""" + Символы.ПС);
		ФайлОтправки.ДобавитьСтроку(Формат(ВыборкаДокумент.ДатаДокумента + 5*24*60*60, "ДФ=yyyy-MM-dd"));
		                                                    		
		ФайлОтправки.ДобавитьСтроку("--" + Boundary);
		ФайлОтправки.ДобавитьСтроку("Content-Disposition: form-data; name=""therm""" + Символы.ПС);
		ФайлОтправки.ДобавитьСтроку(Формат(ВыборкаДокумент.Терм, "БЛ=0; БИ=1"));
		
		ФайлОтправки.ДобавитьСтроку("--" + Boundary);
		ФайлОтправки.ДобавитьСтроку("Content-Disposition: form-data; name=""summ""" + Символы.ПС);
		ФайлОтправки.ДобавитьСтроку(Формат(ВыборкаДокумент.СуммаЗакуп, "ЧДЦ=2; ЧРД=.; ЧН=; ЧГ=0"));
		
		ФайлОтправки.ДобавитьСтроку("--" + Boundary);
		ФайлОтправки.ДобавитьСтроку("Content-Disposition: form-data; name=""qnt_pos""" + Символы.ПС);
		ФайлОтправки.ДобавитьСтроку(Формат(ВыборкаДокумент.Количество, "ЧДЦ=; ЧН=; ЧГ=0"));
		
		
		//ТЧ
		СтрокаСпискаТоваров = "";
		Выборка = ВыборкаДокумент.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СтрокаСпискаТоваров = СтрокаСпискаТоваров 
			+ Формат(Выборка.КодТовара, "ЧДЦ=; ЧН=; ЧГ=0") + ";"
			+ Выборка.НаименованиеТовара + ";"
			+ Формат(Выборка.Количество, "ЧДЦ=; ЧН=; ЧГ=0") + ";";
			
		КонецЦикла;
		
		СтрокаСпискаТоваров = Лев(СтрокаСпискаТоваров, СтрДлина(СтрокаСпискаТоваров) - 1);
		
		ФайлОтправки.ДобавитьСтроку("--" + Boundary);
		ФайлОтправки.ДобавитьСтроку("Content-Disposition: form-data; name=""pos_table""" + Символы.ПС);
		ФайлОтправки.ДобавитьСтроку(СтрокаСпискаТоваров);
		
		ФайлОтправки.ДобавитьСтроку("--" + Boundary);
		
		
		//ОТПРАВКА
		ФайлОтправки.Записать(ИмяФайлаОтправки, КодировкаТекста.Системная);
		
		ФайлОтправки = Новый Файл(ИмяФайлаОтправки);
		РазмерФайлаОтправки = XMLСтрока(ФайлОтправки.Размер());
		
		ЗаголовокHTTP = Новый Соответствие();
		ЗаголовокHTTP.Вставить("POST",				"/south_stream.php HTTP/1.1");
		ЗаголовокHTTP.Вставить("Host",				"lk.ave-apteka.ru");
		ЗаголовокHTTP.Вставить("Content-Type",		"multipart/form-data; boundary=" + Boundary);
		ЗаголовокHTTP.Вставить("Content-Length",	РазмерФайлаОтправки);
		               		
		АдресСервера = "lk.ave-apteka.ru";
		РесурсНаСервере = "south_stream.php";
		
		Соединение = Новый HTTPСоединение(АдресСервера);
		
		ПостЗапрос = Новый HTTPЗапрос(РесурсНаСервере, ЗаголовокHTTP);
		ПостЗапрос.УстановитьИмяФайлаТела(ИмяФайлаОтправки);
		
		ФайлРезультата = ПолучитьИмяВременногоФайла();
		Соединение.ОтправитьДляОбработки(ПостЗапрос, ФайлРезультата);
		Соединение = Неопределено; 		
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтправитьРаспоряжениеНаРеализацию()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РаспоряжениеНаПеремещениеТовар.Ссылка КАК Документ,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Номер КАК НомерДокумента,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Дата КАК ДатаДокумента,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Склад.Наименование КАК НаименованиеАптеки,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Получатель.Наименование КАК НаименованиеПолучателя,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Склад.Мэйл КАК Мэйл,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Код КАК КодТовара,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Наименование КАК НаименованиеТовара,
	|	СУММА(РаспоряжениеНаПеремещениеТовар.Количество) КАК Количество
	|ИЗ
	|	Документ.РаспоряжениеНаПеремещение.Товар КАК РаспоряжениеНаПеремещениеТовар
	|ГДЕ
	|	РаспоряжениеНаПеремещениеТовар.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	РаспоряжениеНаПеремещениеТовар.Ссылка,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Код,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Наименование,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Номер,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Дата,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Склад.Наименование,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Склад.Мэйл,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Получатель.Наименование
	|ИТОГИ ПО
	|	Документ";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДокумент = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаДокумент.Следующий() Цикл
		
		ТемаПисьма = "Распоряжение на реализацию №" + Формат(ВыборкаДокумент.НомерДокумента, "ЧДЦ=; ЧГ=0");
		
		ТекстПисьма = 		
		"Добрый день.<BR />"	
		
		+ "Данным распоряжением необходимо затребованный во вложении товар собрать к отправке. " 
		+ "Вам необходимо в АРМ директора сформировать на основании данного распоряжения "
		+ "расходный документ на реализацию товара. В случае причин, не позволяющих реализовать " 
		+ "какой-либо товар, Вам необходимо заполнить таблицу с указанием причин.<BR />"
		
		+ "Далее необходимо войти в личный кабинет АВЕ в раздел: ""Перемещения"", "
		+ "найти в журнале поступивших заявок на мелкооптовую реализацию соответствующую заявку, " 
		+ "указать в данной заявке количество мест, в которое удалось собрать товар и признак ""холодный"", " 
		+ "в случае, если часть товара требует транспортировки при специальных температурных условиях, " 
		+ "и проставить признак подтверждения, что заявка Вами собрана и готова к отправке.<BR />" 
		
		+ "Также необходимо из личного кабинета распечатать ярлыки и наклеить их на коробки с товаром.<BR />" 
		
		+ "Термолабильный товар упаковывается отдельно и вывозится в термоконтейнере с хладоэлементами!";
			
			
		// Формируем файл для вложения
		ТабДок = Новый ТабличныйДокумент;
		
		Макет = ПолучитьМакет("РеестрРаспоряженийНаРеализацию");
		
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");	
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		
		ОбластьШапка.Параметры.Заполнить(ВыборкаДокумент);
		ОбластьШапка.Параметры.НомерДокумента = Формат(ВыборкаДокумент.НомерДокумента, "ЧДЦ=; ЧГ=0");
		ОбластьШапка.Параметры.ДатаДокумента = Формат(ВыборкаДокумент.ДатаДокумента, "ДФ=dd.MM.yyyy");
		
		ТабДок.Вывести(ОбластьШапка);
		
		ВыборкаДетальныеЗаписи = ВыборкаДокумент.Выбрать();
		
		Счетчик = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Счетчик = Счетчик + 1;
			
			ОбластьСтрока.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
			ОбластьСтрока.Параметры.НомерДокумента = Формат(ВыборкаДокумент.НомерДокумента, "ЧДЦ=; ЧГ=0");
			ОбластьСтрока.Параметры.НомерСтроки = Счетчик;
			ТабДок.Вывести(ОбластьСтрока);
			
		КонецЦикла;
		
		ИмяФайлаВложения = КаталогВременныхФайлов() + "Распоряжение на реализацию.xls";
		ТабДок.Записать(ИмяФайлаВложения, ТипФайлаТабличногоДокумента.XLS);		
		
		
		ОтправкаПисьма(ВыборкаДокумент.Мэйл, ТемаПисьма, ТекстПисьма, ИмяФайлаВложения);
		
	КонецЦикла;  	

КонецПроцедуры

Процедура ОтправитьРаспоряжениеНаПеремещение()
	
	//ТСО {24.02.2015 #0006}

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РаспоряжениеНаПеремещениеТовар.Ссылка КАК Документ,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Номер КАК НомерДокумента,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Дата КАК ДатаДокумента,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Склад.Наименование КАК НаименованиеАптеки,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.СкладПолучатель.Наименование КАК НаименованиеПолучателя,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Склад.Мэйл КАК Мэйл,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Код КАК КодТовара,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Наименование КАК НаименованиеТовара,
	|	СУММА(РаспоряжениеНаПеремещениеТовар.Количество) КАК Количество,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Холодильник КАК Холод,
	|	РаспоряжениеНаПеремещениеТовар.Партия.СерияСтрока КАК Серия,
	|	РаспоряжениеНаПеремещениеТовар.Партия.СрокГодности КАК СрокГодности
	|ИЗ
	|	Документ.РаспоряжениеНаПеремещение.Товар КАК РаспоряжениеНаПеремещениеТовар
	|ГДЕ
	|	РаспоряжениеНаПеремещениеТовар.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	РаспоряжениеНаПеремещениеТовар.Ссылка,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Код,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Наименование,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Номер,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Дата,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Склад.Наименование,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.СкладПолучатель.Наименование,
	|	РаспоряжениеНаПеремещениеТовар.Ссылка.Склад.Мэйл,
	|	РаспоряжениеНаПеремещениеТовар.Товар.Холодильник,
	|	РаспоряжениеНаПеремещениеТовар.Партия.СерияСтрока,
	|	РаспоряжениеНаПеремещениеТовар.Партия.СрокГодности
	|ИТОГИ ПО
	|	Документ";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДокумент = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаДокумент.Следующий() Цикл
		
		ТемаПисьма = "Распоряжение на перемещение №" + Формат(ВыборкаДокумент.НомерДокумента, "ЧДЦ=; ЧГ=0");
		
		ТекстПисьма = 		
		"Добрый день.<BR />"	
		
		+ "Данным распоряжением необходимо затребованный во вложении товар собрать к перемещению. " 
		+ "Вам необходимо в АРМ директора сформировать на основании данного распоряжения "
		+ "документ на перемещение товара. О готовности перемещения довести до сведения " 
		+ "руководителя по управлению ТМЦ Шаторную Ирину Георгиевну сообщив на е-мейл: "		
		+ "<a href=""mailto:i.shatornaya@ave-apteka.ru"">i.shatornaya@ave-apteka.ru</a><BR />" 		
		
		+ "На данное перемещение в 1С создано распоряжение на перемещение товара! "
		+ "Перед проведением документа на перемещение в аптеке необходимо обязательно убедиться, "
		+ "что данное перемещение не дублирует одно из предыдущих!<BR />"
		
		+ "Перемещение осуществлять строго согласно действующего регламента!";
		  
			
		// Формируем файл для вложения
		ТабДок = Новый ТабличныйДокумент;
		
		Макет = ПолучитьМакет("РеестрРаспоряженийНаПеремещение");
		
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");	
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		
		ОбластьШапка.Параметры.Заполнить(ВыборкаДокумент);
		ОбластьШапка.Параметры.НомерДокумента = Формат(ВыборкаДокумент.НомерДокумента, "ЧДЦ=; ЧГ=0");
		ОбластьШапка.Параметры.ДатаДокумента = Формат(ВыборкаДокумент.ДатаДокумента, "ДФ=dd.MM.yyyy");
		
		ТабДок.Вывести(ОбластьШапка);
		
		ВыборкаДетальныеЗаписи = ВыборкаДокумент.Выбрать();
		
		Счетчик = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Счетчик = Счетчик + 1;
			
			ОбластьСтрока.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
			ОбластьСтрока.Параметры.НомерДокумента = Формат(ВыборкаДокумент.НомерДокумента, "ЧДЦ=; ЧГ=0");
			ОбластьСтрока.Параметры.НомерСтроки = Счетчик;
			ТабДок.Вывести(ОбластьСтрока);
			
		КонецЦикла;
		
		ИмяФайлаВложения = КаталогВременныхФайлов() + "Распоряжение на перемещение.xls";
		ТабДок.Записать(ИмяФайлаВложения, ТипФайлаТабличногоДокумента.XLS);		
		
		
		ОтправкаПисьма(ВыборкаДокумент.Мэйл, ТемаПисьма, ТекстПисьма, ИмяФайлаВложения);
		
	КонецЦикла;  	

КонецПроцедуры

Процедура ОтправкаПисьма(Получатель, Тема, Текст, Вложение)
	
	ИПП = Новый ИнтернетПочтовыйПрофиль;
	
	ИПП.АдресСервераSMTP	= Константы.АдресСервераSMTP.Получить();
	ИПП.Таймаут	 	 		= Константы.ВремяОжидания.Получить();
	ИПП.Пароль				= Константы.ПарольПочтыСклада.Получить();
	ИПП.ПарольSMTP			= Константы.ПарольПочтыСклада.Получить();
	ИПП.Пользователь		= Константы.ИмяПользователяПочты.Получить();
	ИПП.ПользовательSMTP	= ИПП.Пользователь;
	ИПП.ПортSMTP			= Константы.ПортSMTP.Получить();
	Отправитель				= Константы.ПользовательПочты.Получить();
	
	Сообщение = Новый ИнтернетПочтовоеСообщение;
	
	Сообщение.Получатели.Добавить(Получатель);
	Сообщение.Получатели.Добавить("i.shatornaya@ave-apteka.ru");
	
	Сообщение.Отправитель.Адрес = Отправитель;
	Сообщение.Тема = Тема;
	Сообщение.Тексты.Добавить(Текст, ТипТекстаПочтовогоСообщения.HTML);
	
	Сообщение.Вложения.Добавить(Вложение);
	
	
	Почта = Новый ИнтернетПочта;
	
	Почта.Подключиться(ИПП);
	Почта.Послать(Сообщение);
	Почта.Отключиться();
	
КонецПроцедуры

﻿Перем Комец Экспорт;
Перем Ком   Экспорт;
Перем ДатаОстатка Экспорт;
Перем Document;


процедура ___Предупреждение(Текст,Таймаут=0)
	#Если толстыйКлиент Тогда
		Предупреждение(Текст,Таймаут);
	#КонецЕсли
	
	#Если ТонкийКлиент ТОгда
		ПоказатьПредупреждение(,Текст,Таймаут,"Внимание!");
	#Конецесли	
	
	
КонецПроцедуры	

процедура ___ОчиститьСообщения()
	
	#Если не Сервер Тогда
		ОчиститьСообщения();
	#КонецЕсли	
	
	
КонецПроцедуры	



Функция ИмяТекущейИБ() Экспорт
	СтрСоед=СтрокаСоединенияИнформационнойБазы() ;//Srvr="1c-s1";Ref="ххх_ууу_ыыы";
	ПозРеф=Найти(СтрСоед,"Ref=");
	Стр=Сред(СтрСоед,ПозРеф,СтрдЛина(СтрСоед));
	Стр=СтрЗаменить(Стр,"Ref=""","");
	Стр=СтрЗаменить(Стр,""";","");
	
	Возврат Стр;
КонецФункции	

Процедура МодОб_ПодключитьсяНажатие(ФайловаяБаза,Сервер,База,КаталогИБ,Пользователь,Пароль,ЭлементыФормы_Н_СостояниеПодключения,Версия1С)  Экспорт
	
	//Параметры:
	//<Строка соединения> (обязательный)
	//Тип: Строка. Строка параметров, используемая 1С:Предприятием 
	//для соединения с информационной базой.
	//Строка соединения представляет собой набор параметров, каждый из которых является фрагментом вида: 
	//<Имя параметра=><Значение>, 
	//где Имя параметра — имя параметра, а Значение — его значение. 
	//Фрагменты отделяются друг от друга символами ';'. 
	//Если значение содержит пробельные символы, то оно должно быть заключено в двойные кавычки (").
	//Для файлового варианта определен параметр: 
	//File — каталог информационной базы (файловый режим);
	//Для клиент-серверного варианта определены параметры: 
	//Srvr — имя сервера 1С:Предприятия; 
	//Ref — имя информационной базы на сервере;
	//Для всех вариантов определены параметры: 
	//Usr — имя пользователя; 
	//Pwd — пароль и UC<Код доступа> позволяет выполнить установку соединения с информационной базой, 
	//на которую установлена блокировка установки соединений. 
	//Если при установке блокировки задан непустой код доступа, то для установки соединения 
	//необходимо в параметре /UC указать этот код доступа. 
	
	Если ФайловаяБаза=Ложь ТОгда
		СтрокаСоединения="Srvr="""+Сервер+"""; Ref="""+База+"""; ";
	Иначе
		СтрокаСоединения="File="""+КаталогИБ+"""; " ;
	КонецЕсли;
	
	СтрокаСоединения=СтрокаСоединения+" Usr="""+Пользователь+"""; Pwd="""+Пароль+""""; 		
	
	ИмяПодключенойБазы="";
	
	КонВерсия1С=СтрЗаменить(Версия1С,".","");
	
	
	Попытка
		
		Комец=Новый COMObject("V"+КонВерсия1С+".COMConnector");
		
		СостояниеПодключения="База: Подключаем ("+База+")...";
		ЭлементыФормы_Н_СостояниеПодключения.Заголовок =СостояниеПодключения;
		
		Ком=Комец.Connect(СтрокаСоединения);
		
		СостояниеПодключения="База: ПОДКЛЮЧЕНА ("+База+")";
		ЭлементыФормы_Н_СостояниеПодключения.Заголовок =СостояниеПодключения;
		
		ИмяПодключенойБазы=База;
	Исключение
		
		
		___предупреждение("Не удалось подключиться к базе! Причина 
		|"+ОписаниеОшибки());
		
		СостояниеПодключения="База: НЕ ПОДКЛЮЧЕНО!!!";
		ЭлементыФормы_Н_СостояниеПодключения.Заголовок =СостояниеПодключения;
		ИмяПодключенойБазы="";
		
	КонецПопытки;
КонецПроцедуры

Функция СконвертироватьКомТЗВНормальнуюТЗ_ССостТипом(КомТЗ) Экспорт
	
	ТЗ=Новый ТаблицаЗначений;
	
	ПерваяСтрока=КомТЗ.Получить(0);
	
	Для каждого  Кол Из КомТЗ.Колонки  Цикл
		КваС=Новый КвалификаторыСтроки(200,ДопустимаяДлина.Переменная);
		КваЧ=Новый КвалификаторыЧисла(15,2,ДопустимыйЗнак.Любой);
		КваД=Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
		ОписТип=Новый ОписаниеТипов("Строка,Число,Дата",КваЧ,КваС,КваД);
		ТЗ.Колонки.Добавить(Кол.ИМЯ,ОписТип);
	КонецЦикла; 
	
	
	Для каждого  КомСтр Из КомТЗ Цикл
		
		Стр=ТЗ.Добавить();
		
		Для Ы=0 По КомТЗ.Колонки.Количество()-1 Цикл
			Стр.Установить(Ы, КомСтр.Получить(Ы));
		КонецЦикла;
	КонецЦикла; 
	
	Возврат ТЗ;
КонецФункции



Функция СконвертироватьКомТЗВНормальнуюТЗ(КомТЗ) Экспорт
	
	ТЗ=Новый ТаблицаЗначений;
	
	Попытка
		ПерваяСтрока=КомТЗ.Получить(0);
	Исключение
		Возврат Новый ТаблицаЗначений;
	КонецПопытки;
	
	
	Ы=0;
	Для каждого  Кол Из КомТЗ.Колонки  Цикл
		
		ЗначениеКолонкиЫ=ПерваяСтрока.Получить(Ы);
		
		Если ТипЗнч(ЗначениеКолонкиЫ)= Тип("Строка") Тогда
			КваС=Новый КвалификаторыСтроки(0,ДопустимаяДлина.Переменная);
			ОписТип=Новый ОписаниеТипов("Строка",,,,КваС,);
			
		ИначеЕсли ТипЗнч(ЗначениеКолонкиЫ)= Тип("Число") Тогда
			КваЧ=Новый КвалификаторыЧисла(15,2,ДопустимыйЗнак.Любой);
			ОписТип=Новый ОписаниеТипов("Число",,,КваЧ,,);
		ИначеЕсли ТипЗнч(ЗначениеКолонкиЫ)= Тип("Дата") Тогда
			КваД=Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
			ОписТип=Новый ОписаниеТипов("Дата",,,,,КваД);
		КонецЕсли;
		
		Ы=Ы+1;
		
		
		ТЗ.Колонки.Добавить(Кол.ИМЯ,ОписТип);
	КонецЦикла; 
	
	МаксЫ=Ы-1;
	
	
	Для каждого  КомСтр Из КомТЗ Цикл
		
		Стр=ТЗ.Добавить();
		
		Для Ы=0 По МаксЫ Цикл
			Стр.Установить(Ы, КомСтр.Получить(Ы));
		КонецЦикла;
	КонецЦикла; 
	
	Возврат ТЗ;
КонецФункции	


Функция МассивДляОО(scr)
	
	scr.language = "javascript";
	scr.eval("Массив=new Array()");
	Массив = scr.eval("Массив");
	
	Возврат Массив; 
КонецФункции


Функция ФайлДляОО(strFile)
	
	strFile1 = СтрЗаменить(strFile, "\", "/") ;
	strFile1 = СтрЗаменить(strFile1, ":", "|");
	strFile1 = СтрЗаменить(strFile1, " ", "%20") ;
	strFile1 = "file:///" + strFile1;
	
	ConvertToUrl = strFile1;
	
	Возврат ConvertToUrl;
КонецФункции	

Функция ПолучитьЛистИзФайла(Файл,ИндексЛиста)
	
	scr = Новый COMОбъект("MSScriptControl.ScriptControl");
	scr=МассивДляОО(scr);
	
	
	ServiceManager=Новый COMОбъект("com.sun.star.ServiceManager"); // через него идет обращение к ОО
	
	Desktop = ServiceManager.createInstance("com.sun.star.frame.Desktop");  
	
	ООФайлУРЛ=ФайлДляОО(Файл);
	
	Попытка
		
		Document = Desktop.LoadComponentFromURL(ООФайлУРЛ ,"_blank", ИндексЛиста, scr);                                 
		
		Листы = Document.getSheets();
		Лист = Листы.getByIndex(ИндексЛиста);
		Возврат Лист;
	ИСключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции	


Функция СформироватьОписаниеТиповПоСтрокеТипизации(СтрокаТипизации)
	
	Если СтрокаТипизации.Тип="Строка" Тогда
		Возврат Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(СтрокаТипизации.Длина,ДопустимаяДлина.Фиксированная));
	ИначеЕсли СтрокаТипизации.Тип="Число" Тогда	
		Возврат Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(СтрокаТипизации.Длина,СтрокаТипизации.Точность,ДопустимыйЗнак.Любой));
	ИначеЕсли 	СтрокаТипизации.Тип="Дата" Тогда	
		Возврат Новый ОписаниеТипов("Дата", Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя));
	ИначеЕсли СтрокаТипизации.Тип="Булево" Тогда	
		Возврат Новый ОписаниеТипов("Булево");
	КонецЕсли;	
	
КонецФункции	


Функция  СоздатьКолонкиПоФайлу(ДанныеИзФайла,Лист,ИндСтроки,ИндексПервойКолонки,КолвоКолонок,ТабТипизацииОО)
	МИК=Новый Массив;
	ЗаменяемыеБуквы=" -!""№;%:?*()/|,.\'`~@^&[]{}";
	
	КК=0;
	Для Ы =ИндексПервойКолонки по ИндексПервойКолонки+КолвоКолонок-1 Цикл
		попытка
			ИмяКол=Лист.getCellByPosition(Ы,ИндСтроки).getString();
		исключение
			если  найти(описаниеошибки(),"IndexOutOfBoundsException")<>0 Тогда
				КолвоКолонок=КК;
				Прервать;
			КонецЕсли;;
		КонецПопытки;
		КК=КК+1;
		Для Ж=1 по СтрДлина(ЗаменяемыеБуквы) Цикл
			ИмяКол=СокрЛП(СтрЗаменить(ИмяКол,Сред(ЗаменяемыеБуквы,Ж,1),""));
			
		КонецЦикла;
		Если ПустаяСтрока(ИмяКол)=Истина Тогда
			ИмяКол="Колонка_"+Ы;
		КонецЕсли;
		
		
		СтрокаТипизации=ТабТипизацииОО.Найти(Ы,"ИндексКолонки");
		
		Если СтрокаТипизации<>Неопределено ТОгда
			Типизация=СформироватьОписаниеТиповПоСтрокеТипизации(СтрокаТипизации);
		Иначе
			Типизация=Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(150,ДопустимаяДлина.Переменная)); // тип по умолчанию
		КонецЕсли;
        
        Попытка
            ДанныеИзФайла.Колонки.Добавить(СокрЛП(Лев(ИмяКол,15)),Типизация);
            МИК.Добавить(ИмяКол);
        Исключение
            ИмяКол="Колонка_"+Ы;
            ДанныеИзФайла.Колонки.Добавить(СокрЛП(Лев(ИмяКол,15)),Типизация);
            МИК.Добавить(ИмяКол); 
        Конецпопытки;    
        
	КонецЦикла;
	
	Возврат МИК;
КонецФункции

Функция  ЗагрузитьФайлЧерезОО(Файл,ИндексЛиста,ИндексПервойСтроки,ИндексПервойКолонки,КолвоКолонок,КолвоСтрокФайла,ТабТипизацииОО) Экспорт
	___ОчиститьСообщения();
	Если ПустаяСтрока(Файл)=Истина Тогда
		___Предупреждение("Не указан файл!");
		Возврат Неопределено;
	КонецЕсли;
	
	Лист=ПолучитьЛистИзФайла(Файл,ИндексЛиста);
	
	Если Лист=Неопределено Тогда
		___Предупреждение("Не удалось получить лист из файла!");
		Возврат Неопределено;
	КонецЕсли;	
	
	//координаты первой ячейки таблицы (столбец,строка) =(0,0)
	//Получить данные из ячейки  Лист.getCellByPosition(ИндСтолбца,ИндСтроки).getString();
	
	ЗаписиЗакончились=ЛОжь;
	ИндСтроки=ИндексПервойСтроки-1;
	
	ДанныеИзФайла=Новый ТаблицаЗначений;
	
	МассивИменКолонок=СоздатьКолонкиПоФайлу(ДанныеИзФайла,Лист,ИндСтроки,ИндексПервойКолонки,КолвоКолонок,ТабТипизацииОО);
	
	Для ДФ=1 По КолвоСтрокФайла Цикл
		Если ИндСтроки+1=КолвоСтрокФайла Тогда
			Прервать;
		КонецЕсли;	
		
		ИндСтроки=ИндСтроки+1;// первая строка с данными
		
		Стр=ДанныеИзФайла.Добавить();
		ИндКолМИК=0;
		ДЛя Х=ИндексПервойКолонки по ИндексПервойКолонки+КолвоКолонок-1 Цикл
			ИмяКол=МассивИменКолонок.получить(ИндКолМИК);
			
			ЗначООСтрокой= СокрЛП(Лист.getCellByPosition(Х,ИндСтроки).getString()  );
			
						
			СтрокаТипизации=ТабТипизацииОО.Найти(Х,"ИндексКолонки");
			
			Если СтрокаТипизации<>Неопределено Тогда
				#Если клиент тогда
				Состояние("Строка: "+ИндСтроки+"  Колонка: "+Х);
				#КонецЕсли

				
				Если СтрокаТипизации.Тип="Строка" Тогда
					ЗначОО=ЗначООСтрокой;
				ИначеЕсли СтрокаТипизации.Тип="Число" Тогда
					ЗначООСтрокой=СтрЗаменить(ЗначООСтрокой,",",".");
					ЗначООСтрокой=СтрЗаменить(ЗначООСтрокой," ","");
					ЗначООСтрокой=СтрЗаменить(ЗначООСтрокой," ","");

					Попытка
						ЗначОО=Число(ЗначООСтрокой);
					Исключение
						Сообщить("Кривое число! "+ОписаниеОшибки()+"  "+ "Строка(индекс): "+ИндСтроки+"  Колонка(индекс): "+Х +" Кривое значение "+СокрЛП(Лист.getCellByPosition(Х,ИндСтроки).getString()  ));
						ВызватьИсключение;
					КонецПопытки;
					
				ИначеЕсли СтрокаТипизации.Тип="Дата" Тогда
					Попытка
						ЗначОО=Дата(ЗначООСтрокой);
					Исключение
						ЗначОО=Дата(1,1,1);
					КонецПопытки;
					
				ИначеЕсли  СтрокаТипизации.Тип="Булево" Тогда
					Если ЗначООСтрокой="ИСТИНА" или ЗначООСтрокой="1"Тогда ЗначОО=Истина
					ИначеЕсли ЗначООСтрокой="ЛОЖЬ" или ЗначООСтрокой="0" Тогда ЗначОО=ЛОЖЬ
					КонецЕсли;
				КонецЕсли;	
			Иначе
				ЗначОО=ЗначООСтрокой; // по умолчанию
			КонецЕсли;	
			
			
			
			
			стр[ИмяКол]=ЗначОО ;
			
			ИндКолМИК=ИндКолМИК+1;
		КонецЦикла;	
	КонецЦикла;	
	
	
	
	
	Document.Close(1);
	Document=Неопределено; //убьем объект ОО
	
	Возврат ДанныеИзФайла;
КонецФункции	

Функция GTGКаталогВременныхФайлов() Экспорт
	
		СоздатьКаталог("D:\GTG_Console_TMP");

		
	
	Возврат  "D:\GTG_Console_TMP\";
	
	
	
	
	
КонецФункции

	
	
	



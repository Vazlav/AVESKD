﻿ Перем Document;

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

Функция СконвертироватьДату(ПсевдоДата)
	
	//31.05.2011
	
	пДатаГод=Прав(ПсевдоДата,4); //2011
	пДатаДень=Лев(ПсевдоДата,2);   //31
	пДатаМесяц=Сред(ПсевдоДата,4,2); //05
	
	Строкадата=""+пДатаГод+пДатаМесяц+пДатаДень;
	
	Если ПустаяСтрока(Строкадата)=Ложь ТОгда 
		Возврат  Дата(""+Строкадата+"000000"); //20110531000000
	Иначе
		Возврат "";
	КонецЕсли;	
	
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
		Лист = Листы.getByIndex(0);
		Возврат Лист;
	ИСключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции	

Функция ОткрытьФайлОО(Файл) Экспорт
	ОчиститьСообщения();
	Если ПустаяСтрока(Файл)=Истина Тогда
		Предупреждение("Не выбран файл!");
		Возврат Неопределено;
	КонецЕсли;
	
	Лист=ПолучитьЛистИзФайла(Файл,0);
	
	Если Лист=Неопределено Тогда
		Предупреждение("Не удалось получить лист из файла!");
		Возврат Неопределено;
	КонецЕсли;	
	
	//координаты первой ячейки таблицы (столбец,строка) =(0,0)
	//Получить данные из ячейки  Лист.getCellByPosition(ИндСтолбца,ИндСтроки).getString();
	
	ТЗ=Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Код");
	ТЗ.Колонки.Добавить("Наименование");
	ТЗ.Колонки.Добавить("План");
	
	//---------------<Получим период расчетов. (из расчета что это файл за один день)>---------------------------// GtG // 20.08.2012 12:14:21
	ЗаписиЗакончились=ЛОжь;
	ИндСтроки=0;
	
	
	//---------------------------------------------------------------------					
	КодАптеки=0;
	НаименованиеАптеки=1;
	колПлан=2;
	//---------------------------------------------------------------------					
	Пока ЗаписиЗакончились=Ложь Цикл
		
		ИндСтроки=ИндСтроки+1;// первая строка с данными №2;
		
		ИД=СокрЛП(Лист.getCellByPosition(КодАптеки,ИндСтроки).getString());
		Если ПустаяСтрока(ИД)=Истина Тогда
			ЗаписиЗакончились=Истина;
			Прервать;
		КонецЕсли;	
		
		СтрТЗ=ТЗ.Добавить();
		
		//СписокВозврата.Добавить(Число(СокрЛП(Лист.getCellByPosition(IDКод,ИндСтроки).getString())));
		
		СтрТЗ.Код=Число(Лист.getCellByPosition(КодАптеки,ИндСтроки).getString());
		СтрТЗ.Наименование=СокрЛП(Лист.getCellByPosition(НаименованиеАптеки,ИндСтроки).getString());
		СтрТЗ.План=Число(Лист.getCellByPosition(колПлан,ИндСтроки).getString());
		
	КонецЦикла;	
	
	
	Document.Close(1);
	Document=""; //убьем объект ОО
	
	Возврат ТЗ;
		
КонецФункции




﻿Перем Сканер Экспорт;
Перем ГлобальноеУдалениеЗаписейАП Экспорт;
Перем глФирма Экспорт;
 //==========================================================Virus====
Процедура ПодключитьСканер()

	Попытка
	
		ЗагрузитьВнешнююКомпоненту("ScanOPOS.dll");
		Сканер = Новый("AddIn.Scanner");
	//    Сканер.Занять(1);
		
	Сканер.Open(1);  //Замедьте если раньше можно было написать СканерШтрихКода.Open(1) то теперь 8.0 зависнет от такой команды!!!
    Сканер.Claim(1);
    Сканер.ClearInput();
    Сканер.ClearOutput();
	Исключение
	    Состояние("Сканер не подключен!");
	КонецПопытки;

КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
Если Событие="BarCodeValue"    Тогда    
       Состояние ("Сброс...");
       Сканер.Open(1);
       Сканер.Claim(1);
       Сканер.ClearInput();
       Сканер.ClearOutput();
       Состояние ("...готово");
	   //Сообщить(Источник + " - " + Событие + " - " + Данные);
КонецЕсли;
КонецПроцедуры  

Процедура ОбработчикОжидания_ПриНачалеРаботыСистемы() Экспорт
	#Если Клиент ТОгда
	ОтключитьОбработчикОжидания("ОбработчикОжидания_ПриНачалеРаботыСистемы");
	пл_ВремяЗавершенияРаботы =  Константы.ВремяЗавершениеРаботыПользователей.Получить();
	Если пл_ВремяЗавершенияРаботы>ОМ3_ПустаяДата() Тогда
		Если ТекущаяДата()<пл_ВремяЗавершенияРаботы Тогда
			пл_ОсталосьСекВсего = пл_ВремяЗавершенияРаботы-ТекущаяДата();
			Если пл_ОсталосьСекВсего<10*60 Тогда
				пл_ОсталосьЧас		= Цел(пл_ОсталосьСекВсего/3600);
				пл_ОсталосьМин		= Цел((пл_ОсталосьСекВсего-пл_ОсталосьЧас*3600)/60);
				пл_ОсталосьСек		= пл_ОсталосьСекВсего-Цел(пл_ОсталосьСекВсего/60)*60;
				
				пл_Текст = "ВНИМАНИЕ!!! В "+Формат(пл_ВремяЗавершенияРаботы,"ДЛФ=T")+" программа закроется автоматически. Осталось: "+Прав("0"+Строка(пл_ОсталосьЧас),2)+":"+Прав("0"+Строка(пл_ОсталосьМин),2)+":"+Прав("0"+Строка(пл_ОсталосьСек),2)+" (Просьба своевременно сохранить данные и завершить работу)";
				Сообщить(пл_Текст);
				Если пл_ОсталосьСекВсего<3*60 Тогда
					Сигнал();
					Предупреждение(пл_Текст,10);
				КонецЕсли;
			КонецЕсли;
		Иначе
			пл_ИмяПользователя = ВРег(ИмяПользователя());
			Если пл_ИмяПользователя<>"АДМИНИСТРАТОР" и пл_ИмяПользователя<>"РОБОТ" Тогда
				ЗавершитьРаботуСистемы(Ложь);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ПодключитьОбработчикОжидания("ОбработчикОжидания_ПриНачалеРаботыСистемы", 120, Ложь);
	#КонецЕсли
КонецПроцедуры

Процедура НайтиФайлЛицензии(Результат) Экспорт
	
	РезПоиска82=НайтиФайлы("C:\ProgramData\1C\1Cv82\conf","2*.lic");
    РезПоиска83=НайтиФайлы("C:\ProgramData\1C\licenses","2*.lic");
    
    РезПоиска=Новый Массив;
    
    Для Каждого Элем Из РезПоиска82 Цикл
        РезПоиска.Добавить(Элем);
    КонецЦикла;    
    
    Для Каждого Элем Из РезПоиска83 Цикл
        РезПоиска.Добавить(Элем);
    КонецЦикла;    
    

    
    
    
    
	Если РезПоиска.Количество()=0 Тогда
		ЗаписьЖурналаРегистрации("GTGLocalLicInfo",,,,""+ИмяКомпьютера()+" "+ИмяПользователя()+" НЕТ ЛОКАЛЬНОЙ ЛИЦЕНЗИИ!");
		Возврат;
	КонецЕсли;
	
	//============ Пишем в журнал регистрации ===================
	ИнформацияОЛицензиях="";
	Для Каждого Ф Из РезПоиска Цикл
		ИнформацияОЛицензиях=ИнформацияОЛицензиях+Ф.ПолноеИмя+Символы.ПС;
	КонецЦикла;	
	
	
	СообщениеЖР=""+ИмяПользователя()+"  "+ИмяКомпьютера()+"   "+ ИнформацияОЛицензиях;
	
	ЗаписьЖурналаРегистрации("GTGLocalLicInfo",,,,СообщениеЖР);
	
	Результат=ИнформацияОЛицензиях;
	
	
Конецпроцедуры

//============================================================================ GtG ===
Процедура ЗаполнитьВидыДокументов()
	
	НачатьТранзакцию();
	
	Для Каждого Документ Из Метаданные.Документы Цикл
		
		ВидДокумента = Справочники.ВидыДокументов.НайтиПоКоду(Документ.Имя);
		Если ВидДокумента.Пустая() Тогда
			ВидДокумента = Справочники.ВидыДокументов.СоздатьЭлемент();
			ВидДокумента.Код = Документ.Имя;
			ВидДокумента.Наименование = Документ.Синоним;
			ВидДокумента.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыДокументов.Ссылка,
	|	ВидыДокументов.Код
	|ИЗ
	|	Справочник.ВидыДокументов КАК ВидыДокументов";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Документ = Метаданные.Документы.Найти(СокрЛП(Выборка.Код));
		Если Документ = Неопределено Тогда
			Выборка.Ссылка.ПолучитьОбъект().Удалить();
		КонецЕсли;	
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ЗаполнитьРегламентныеЗадания()
	
	НачатьТранзакцию();
	
	Для Каждого РеглЗадание Из Метаданные.РегламентныеЗадания Цикл
		
		ТекЗадание = Справочники.РегламентныеЗадания.НайтиПоКоду(РеглЗадание.Имя);
		Если ТекЗадание.Пустая() Тогда
			ТекЗадание = Справочники.РегламентныеЗадания.СоздатьЭлемент();
			ТекЗадание.Код = РеглЗадание.Имя;
			ТекЗадание.Наименование = РеглЗадание.Синоним;
			ТекЗадание.Записать();
		КонецЕсли;
		
	КонецЦикла;	
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры


Функция ПолучитьИмяБазыДанных() Экспорт
	ССИБ=СтрокаСоединенияИнформационнойБазы();
	ПозРеф=Найти(ССИБ,"Ref=");
	ССИБ=Сред(Ссиб,ПозРеф,СтрДлина(Ссиб));
	
	ПозЗпТч=Найти(ССИБ,";");
	ССИБ=Сред(ССИБ,1,ПозЗпТч-1);
	ССИБ=СтрЗаменить(ССИБ,"""","");
	ССИБ=СтрЗаменить(ССИБ,"Ref=","");
	
	Возврат ССИБ;
КонецФункции	

Процедура ЗапуститьРобота(КодРоботаСтрока)
	
	Попытка
		КодРоботаЧисло = Число(КодРоботаСтрока);
	Исключение
		Возврат;
	КонецПопытки;
	
	Робот = Справочники.Роботы.НайтиПоКоду(КодРоботаЧисло);
	Если НЕ Робот.Пустая() Тогда
		Если НЕ ПустаяСтрока(Робот.ПутьКОбработке) Тогда
			ВнешняяОбработка = ВнешниеОбработки.Создать(Робот.ПутьКОбработке);
			ФормаОбработки = ВнешняяОбработка.ПолучитьФорму();
			Если НЕ ВнешняяОбработка.Метаданные().Реквизиты.Найти("КодАптекиНачальный") = Неопределено Тогда
				ВнешняяОбработка.КодАптекиНачальный = Робот.КодАптекиНачальный;
				ВнешняяОбработка.КодАптекиКонечный	= Робот.КодАптекиКонечный;
			Иначе
				Если НЕ ФормаОбработки.ЭлементыФормы.Найти("КодАптекиНачальный") = Неопределено Тогда
					ФормаОбработки.КодАптекиНачальный = Робот.КодАптекиНачальный;
					ФормаОбработки.КодАптекиКонечный = Робот.КодАптекиКонечный;
				КонецЕсли;
			КонецЕсли;
			
			Если НЕ ВнешняяОбработка.Метаданные().Реквизиты.Найти("КодыПоставщиков") = Неопределено Тогда
				ВнешняяОбработка.КодыПоставщиков = Робот.КодыПоставщиков;
			КонецЕсли;
			
			Если НЕ ВнешняяОбработка.Метаданные().Реквизиты.Найти("РоботСсылка") = Неопределено Тогда
				ВнешняяОбработка.РоботСсылка = Робот;
			КонецЕсли;

			ФормаОбработки.Открыть();
		Конецесли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы(Отказ) 

	//ADMIN_ОтправитьСписокВерсий1С();
	//GTG_1C_AutoInstall.GTG_АВТОМАТИЧЕСКОЕ_ОБНОВЛЕНИЕ_1С();
	НайтиФайлЛицензии(Неопределено); // GTG //
	GTG_1C_AutoInstall.GTG_АВТОМАТИЧЕСКОЕ_ОБНОВЛЕНИЕ_1С();
	
	
	пл_ВремяЗавершенияРаботы =  Константы.ВремяЗавершениеРаботыПользователей.Получить();
	Если пл_ВремяЗавершенияРаботы>ОМ3_ПустаяДата() Тогда
		пл_ИмяПользователя = ВРег(ИмяПользователя());
		Если пл_ИмяПользователя<>"АДМИНИСТРАТОР" и пл_ИмяПользователя<>"РОБОТ" Тогда
			Если ТекущаяДата()>=пл_ВремяЗавершенияРаботы Тогда
				Отказ = Истина;
				Сигнал();
				ЗавершитьРаботуСистемы(Ложь);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ПодключитьОбработчикОжидания("ОбработчикОжидания_ПриНачалеРаботыСистемы", 120, Ложь);
	 
     // Назначение:
 	// Установить текущего пользователя
 	// 
     // 
 	//--------------------------------------------------------------------------------
	ГлобальноеУдалениеЗаписейАП=Ложь;
	
   ТекущийСотр=""; // параметр сеанса
   
   Сотр = Справочники.Сотрудники.НайтиПоРеквизиту("ИмяПользователя",СокрЛП(ИмяПользователя()),);
   
   Если Сотр.Пустая()=Истина Тогда
	   НовыйСотр = Справочники.Сотрудники.СоздатьЭлемент();
	   НовыйСотр.Наименование=СокрЛП(ПолноеИмяПользователя());
	   НовыйСотр.ИмяПользователя=СокрЛП(ИмяПользователя());
	   НовыйСотр.Записать();
	   
	   ПараметрыСеанса.ТекущийСотр=НовыйСотр.Ссылка;
   Иначе
	   ПараметрыСеанса.ТекущийСотр=Сотр;
	КонецЕсли;    
	ПараметрыСеанса.ИспользоватьШаблоныОграничения = Истина;   
	   
    Состояние("Текущий пользователь: "+ПараметрыСеанса.ТекущийСотр); 
   
	ЕСли Константы.Первые2СимволаПартий.Получить()<>24 Тогда
		Константы.Первые2СимволаПартий.Установить(24);
	КонецЕсли;
	
	ЕСли Константы.Первые2СимволаВШКНеЖНВЛС.Получить()<>25 Тогда
		Константы.Первые2СимволаВШКНеЖНВЛС.Установить(25);
	КонецЕсли;
	
	ЕСли Константы.Первые2СимволаВШКЖНВЛС.Получить()<>26 Тогда
		Константы.Первые2СимволаВШКЖНВЛС.Установить(26);
	КонецЕсли;
	
	Если Константы.ЗадержкаТаймераРобота.Получить()=0 Тогда
		Константы.ЗадержкаТаймераРобота.Установить(120);
	КонецЕсли; 	
	
	Если Константы.МаксимальноДопустимыйПроцентОтклоненияОтПредыдущейЗакупочнойЦены.Получить()=0 Тогда
		Константы.МаксимальноДопустимыйПроцентОтклоненияОтПредыдущейЗакупочнойЦены.Установить(5);
	КонецЕсли; 	

	Если Константы.МинимальныйСрокГодности.Получить()=0 Тогда
		Константы.МинимальныйСрокГодности.Установить(180);
	КонецЕсли; 	
	
	Если Константы.МинимальнаяРазницаПроцентовНаценкиПриКоторойПРименятьСтаруюРознЦену.Получить()=0 Тогда
		Константы.МинимальнаяРазницаПроцентовНаценкиПриКоторойПРименятьСтаруюРознЦену.Установить(10);
	КонецЕсли; 	

	
	
	
	ПараметрыСеанса.КомментарийБеспредела="";
	ПараметрыСеанса.Беспредел=Ложь;
	ПараметрыСеанса.КопированиеАП = Ложь;
	
	
	
	//Если Сотр.РежимРаботы=Перечисления.РежимРаботы.КПК тогда
	//	КПКшка=Обработки.ПриходДля_WinCE.ПолучитьФорму("Форма");
	//	КПКшка.Открыть();
	//КонецЕсли;	
	
	//------------------<Признак бета версии - ползователь с именем ТЕСТЕР1 в справочнике сотрудников>-------------------GtG----29.11.2007
	ТХТ="ВЫБРАТЬ
	    |	Сотрудники.ИмяПользователя
	    |ИЗ
	    |	Справочник.Сотрудники КАК Сотрудники
	    |ГДЕ
	    |	Сотрудники.ИмяПользователя like &Тестер";
		Запрос=Новый Запрос;
		Запрос.Текст=ТХТ;
		Запрос.УстановитьПараметр("тестер","ТЕСТЕР%");
		ТЗ=Запрос.Выполнить().Выгрузить();
		Если ТЗ.Количество()>0 Тогда
			БЕТА=" ---  БЕТА   ВЕРСИЯ   ДЛЯ   ТЕСТИРОВАНИЯ  ---";
		Иначе
			БЕТА="";
		КонецЕсли;
		
	ТХТ="ВЫБРАТЬ
	    |	Сотрудники.ИмяПользователя
	    |ИЗ
	    |	Справочник.Сотрудники КАК Сотрудники
	    |ГДЕ
	    |	Сотрудники.ИмяПользователя like &РОБОТ";
		Запрос=Новый Запрос;
		Запрос.Текст=ТХТ;
		Запрос.УстановитьПараметр("РОБОТ","РОБОТ%");
		ТЗ=Запрос.Выполнить().Выгрузить();
		Если ТЗ.Количество()>0 Тогда
			БЕТА=" ---  РАБОЧАЯ БАЗА  ---";
		КонецЕсли;
	
		
	глФирма = Константы.ОсновнаяФирма.Получить();	
	
	
	
	
	УстановитьЗаголовокСистемы(""+ПолучитьИмяБазыДанных()+" ver.2 "+БЕТА);
	
	//------------------<Подключаем сканер если в константах указан признак работы со сканером>-------------------Virus----16.11.2007
	//Если Константы.РаботаСоСканером = Истина Тогда
	//	ПодключитьСканер();
	//КонецЕсли;
	//--------------------------------------------------------Virus----КОНЕЦ--16.11.2007
	Фн=Отчеты.Новости.ПолучитьФорму("Форма");
	ФН.Открыть();
	
	
	Если РольДоступна("ЧужаяСправочнаяСлужба")=Истина ТОгда
		СС=Обработки.СправочнаяСлужба_v2016.ПолучитьФорму("Форма");
		СС.Открыть();
	КонецЕсли;	
	
	Если РольДоступна("УНИФИЦИРОВАННЫЙ_СПРАВОЧНИК_АПТЕК")=Истина ТОгда
		СС=оТЧЕТЫ.Унифицированный_справочник_аптек.ПолучитьФорму("Форма");
		СС.Открыть();
	КонецЕсли;	
	
	Если РольДоступна("ДозаказАптеки")=Истина ТОгда
		ВнешняяОбработка = Справочники.ВнешниеОтчетыИОбработки.НайтиПоКоду(1194);
		Если ЗначениеЗаполнено(ВнешняяОбработка) Тогда 		
			ФормаОбработки = ВнешниеОбработки.ПолучитьФорму(ВнешняяОбработка.ПутьКФайлу);
			ФормаОбработки.Открыть();
		Иначе	
			Предупреждение("не найдена обработка Дозаказа аптеки!",3);
			Отказ = Истина;
			Сигнал();
			ЗавершитьРаботуСистемы(Ложь);
		КонецЕсли;
	КонецЕсли;

		
		
	//Если Константы.ОсновнаяФирма.Получить().Пустая()=Истина ТОгда
	//	Предупреждение("В константах не указана основная фирма!");
	//Иначе
	//	Если ПустаяСтрока(Константы.ОсновнаяФирма.Получить().ИНН)=Истина ТОгда
	//		Предупреждение("У основной фирмы "+Константы.ОсновнаяФирма.Получить()+" не указан ИНН!");
	// 	КонецЕсли;
	//КонецЕсли;	
	
	ПараметрыСеанса.РазрешитьДействияВЗакрытомПериоде = ПараметрыСеанса.ТекущийСотр.РазрешитьДействияВЗакрытомПериоде;
	
	
	// ---------------- Глобальный каталог временных файлов ----------------------------------------
	ГУИД=Новый УникальныйИдентификатор;
	ПараметрыСеанса.КАТАЛОГ_ВРЕМЕННЫХ_ФАЙЛОВ=КаталогВременныхФайлов()+ ГУИД+"\";
	ОМ17_ПроверитьИСоздатьКаталог(ПараметрыСеанса.КАТАЛОГ_ВРЕМЕННЫХ_ФАЙЛОВ);	
	
	ЗаполнитьВидыДокументов();
    ЗаполнитьРегламентныеЗадания();
	
	Если Не ПустаяСтрока(ПараметрЗапуска) Тогда
		Если Найти(ПараметрЗапуска,"#ZR") > 0 Тогда
			ЗапуститьРобота(СтрЗаменить(ПараметрЗапуска,"#ZR",""));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ)
	
	Если НЕ ВРег(ИмяПользователя()) = "РОБОТ" Тогда
		  Если Вопрос("Закрыть складскую программу?",РежимДиалогаВопрос.ОКОтмена,0,КодВозвратаДиалога.Отмена)=КодВозвратаДиалога.Отмена ТОгда
			  Отказ=Истина;
		  КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗавершенииРаботыСистемы()
	  
	  Попытка
		  УдалитьФайлы(ПараметрыСеанса.КАТАЛОГ_ВРЕМЕННЫХ_ФАЙЛОВ);
	  Исключение
	  КонецПопытки;
	  
КонецПроцедуры

Процедура АдминистративныйДействие() Экспорт
	// Вставить содержимое обработчика.
КонецПроцедуры


  //============================================================================ GtG ===
  
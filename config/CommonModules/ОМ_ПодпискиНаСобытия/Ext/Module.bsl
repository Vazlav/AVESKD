﻿Процедура ЗафиксироватьИзменение(Источник)
	//ДЛя Каждого ОбМет Из Метаданные.Документы Цикл
	//	Если ТипЗнч(Источник)=Тип("ДокументОбъект."+ОбМет.Имя) Тогда
	//		ИмяТипаДокумента=ОбМет.Имя;
	//		Прервать;
	//	КонецЕсли;
	//КонецЦикла;	
	//
	//МенЗап=РегистрыСведений.ДокументыНаПеревыгрузкуВБухгалтерию.СоздатьМенеджерЗаписи();
	//МенЗап.ВидДокумента=ИмяТипаДокумента;
	//МенЗап.Дата=НачалоДня(Источник.Дата);
	//МенЗап.Записать();
КонецПроцедуры

Процедура ПриПроведенииВыгружаемогоВБухгалтериюДокумента(Источник, Отказ, РежимПроведения) Экспорт
	 ЗафиксироватьИзменение(Источник);

КонецПроцедуры

Процедура ПриУдаленииПроведенияВыгружаемогоВБухгалтериюДокумента(Источник, Отказ) Экспорт
	ЗафиксироватьИзменение(Источник);
КонецПроцедуры

Процедура ПриУстановкеСвязкиПриЗаписи(Источник, Отказ) Экспорт

	МенЗап=РегистрыСведений.АудитСвязок.СоздатьМенеджерЗаписи();
	МенЗап.Дата=ТекущаяДата();
	МенЗап.Пользователь = ПараметрыСеанса.ТекущийСотр;
	МенЗап.Товар = Источник.ТоварФирмы;
	МенЗап.Поставщик = Источник.Поставщик;
	МенЗап.КодТовараПоставщика = Источник.КодТовараПоставщика;
	Запрос = Новый Запрос;
	ТХТ = "ВЫБРАТЬ
	      |	Прайсы.Товар
	      |ИЗ
	      |	РегистрСведений.Прайсы КАК Прайсы
	      |ГДЕ
	      |	Прайсы.Поставщик = &Поставщик
	      |	И Прайсы.Код = &Код";
	Запрос.Текст = ТХТ;
	Запрос.УстановитьПараметр("Поставщик",Источник.Поставщик);
	Запрос.УстановитьПараметр("Код",Источник.КодТовараПоставщика);
	Рез = Запрос.Выполнить();
	Если Рез.Пустой() = Ложь Тогда
		Выборка = Рез.Выбрать();
		Выборка.Следующий();	
		МенЗап.НаименованиеТовараПоставщика = Выборка.Товар;
	КонецЕсли;
	МенЗап.Комментарий = "Связка установлена";
	МенЗап.Записать();
	
	
	
КонецПроцедуры

Процедура ПриУдаленииСвязкиПередУдалением(Источник, Отказ) Экспорт
	
	МенЗап=РегистрыСведений.АудитСвязок.СоздатьМенеджерЗаписи();
	МенЗап.Дата=ТекущаяДата();
	МенЗап.Пользователь = ПараметрыСеанса.ТекущийСотр;
	МенЗап.Товар = Источник.ТоварФирмы;
	МенЗап.Поставщик = Источник.Поставщик;
	МенЗап.КодТовараПоставщика = Источник.КодТовараПоставщика;
	Запрос = Новый Запрос;
	ТХТ = "ВЫБРАТЬ
	      |	Прайсы.Товар
	      |ИЗ
	      |	РегистрСведений.Прайсы КАК Прайсы
	      |ГДЕ
	      |	Прайсы.Поставщик = &Поставщик
	      |	И Прайсы.Код = &Код";
	Запрос.Текст = ТХТ;
	Запрос.УстановитьПараметр("Поставщик",Источник.Поставщик);
	Запрос.УстановитьПараметр("Код",Источник.КодТовараПоставщика);
	Рез = Запрос.Выполнить();
	Если Рез.Пустой() = Ложь Тогда
		Выборка = Рез.Выбрать();
		Выборка.Следующий();
		МенЗап.НаименованиеТовараПоставщика = Выборка.Товар;
	КонецЕсли;
	МенЗап.Комментарий = "Связка удалена";
	МенЗап.Записать();
	
	
КонецПроцедуры

Процедура РеализацияККМ_СозданиеОтчетаАптекиКомиссионераОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
    
    ВОЗВРАТ;    // GtG  //  16.04.2014 15:05:49 ОТКЛЮЧЕНО!!!
    
    
	Если Источник.Склад.РаботаТолькоПоКомиссии =ложь ТОгда
		Возврат;
	КонецЕсли;	
	
	
	
	
	//Начинает работать с 01.01.2013
	Если Источник.Дата<Дата("20130101000000") тогда
		Возврат;
	КонецЕсли;	
	//---------------<Одна аптека - один документ - один день>---------------------------// GtG // 12.04.2013 15:36:22
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	ОтчетАптекиКомиссионера.Ссылка
	                    |ИЗ
	                    |	Документ.ОтчетАптекиКомиссионера КАК ОтчетАптекиКомиссионера
	                    |ГДЕ
	                    |	НачалоПериода(ОтчетАптекиКомиссионера.Дата,День) = НачалоПериода(&Дата,день)
	                    |	И ОтчетАптекиКомиссионера.Склад = &Склад
	                    |	И ОтчетАптекиКомиссионера.СкладКомиссионер = &СкладКомиссионер");
						
	Запрос.УстановитьПараметр("Дата",Источник.Дата);
	Запрос.УстановитьПараметр("Склад",Источник.Склад.Комитент  );
	Запрос.УстановитьПараметр("СкладКомиссионер",Источник.Склад  );
	
    СписокУдаляемых=Запрос.Выполнить().Выгрузить();
	Если СписокУдаляемых.Количество()<>0 Тогда
		Для Каждого Стр Из СписокУдаляемых Цикл
			Стр.Ссылка.ПолучитьОбъект().Удалить();
		КонецЦикла;
	КонецЕсли;	
	
	Док=Документы.ОтчетАптекиКомиссионера.СоздатьДокумент();
	
	Док.Дата=Источник.Дата;
	Док.ДокументОснование=Источник.Ссылка;
	Док.НачПериода=НачалоДня(Источник.Дата);
	Док.КонПериода=КонецДня(Источник.Дата);
	
	Док.СкладКомиссионер=Источник.Склад;
	Док.Склад=Док.СкладКомиссионер.Комитент;
	Док.Фирма=Док.Склад.Фирма;
	Док.ФирмаКомиссионер =Источник.Склад.Фирма;
	
	Док.Записать(РежимЗаписиДокумента.Запись);
	
	//---------------<не срабатывает из транзакции проведения выручки.>---------------------------// GtG // 16.01.2013 19:23:33
	// Запустим через Фоновое задание 
	// Асинхронное выполнение кода:
	МассивПараметров=Новый Массив;
	МассивПараметров.Добавить(Док.ссылка);
	
    // При массированном проведении выручки нужно чтобы очередное проведение было уверено в окончании предыдущего в рамках аптеки, иначе
	// асинхронность выполнения может привести к неверному заполнению документов из-за разной скорости обработки документов разной днины.
	// определяем это с помошью ключа КодСклада, дата выручки. Текущее фоновое задание не должно начинать работу если 
	// имеется активное задание обрабатывающее предыдушую дату по такой же аптеке.
	ключ="KEY_DATE:"+Формат(началоДня(Док.Дата),"ДФ=yyyyMMddHHmmss")+"_SKD:"+Формат(Док.Склад.Код,"ЧГ=0");//
	
	
	ФоновыеЗадания.Выполнить("ОМ_ПодпискиНаСобытия.ФоновоеЗаполнениеОтчетаКомиссионера",МассивПараметров,ключ,"ОАК "+Формат(началоДня(Док.Дата),"ДФ=yyyyMMddHHmmss")+" / "+Формат(Док.Склад.Код,"ЧГ=0"));
	
	
		
КонецПроцедуры

Процедура ФоновоеЗаполнениеОтчетаКомиссионера(Докссылка) Экспорт
	  Док=ДокСсылка.ПолучитьОбъект();
	  
	  
	  //---------------<>---------------------------// GtG // 12.04.2013 18:16:30
	  // Проверяем очередь заданий. Документы огромные и при проведении могут взаимно блокироваться.
	  // Нужно соблюсти очередь заполнения и проведения таким образом, 
	  // чтобы одновременно обрабатывался только один документ с самой ранней датой.
	  //
	  // Если накопится очередь из документов разных дат и складов, то обработка произойдет
	  // в порядке возрастания дат и в рамках даты по возрастанию кодов складов.
	  // Это актуально для массированного перепроведения выручек по аптекам-комиссионерам.
	  
	  МожноЗаполнять=ЛОжь;
	  
	  Пока МожноЗаполнять=Ложь Цикл
		  
		  МассифАктивныхФЗ=ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("ИмяМетода,Состояние","ОМ_ПодпискиНаСобытия.ФоновоеЗаполнениеОтчетаКомиссионера",СостояниеФоновогоЗадания.Активно)); // запущенные в данный момент фоновые задания
		  
		  
		  //Наличие очереди определяем по наличию заданий, у которых значение ключа меньше ключа текущего задания
		  
		  КлючЗаданияЭтогоДокумента="KEY_DATE:"+Формат(началоДня(Докссылка.Дата),"ДФ=yyyyMMddHHmmss")+"_SKD:"+Формат(Докссылка.Склад.Код,"ЧГ=0");//
		 
		  
		  Если МассифАктивныхФЗ.Количество()<>0 тогда
			  // из общей кучи выберем задания по документу пришедшему в параметре
			  
			  ЕстьБолееРанниеЗадания=Ложь;
			  Для Каждого Задание из МассифАктивныхФЗ цикл
				  
					  Если Задание.Ключ<КлючЗаданияЭтогоДокумента Тогда
						  ЕстьБолееРанниеЗадания=Истина;
						  Прервать;
					  КонецЕсли;
				  
				  
			  КонецЦикла;
			  
			  //Если ЕстьБолееРанниеЗадания=Истина Тогда
			  //	//ОбщегоНазначения.Задержка(2); // подождем 2 сек // при большой очереди самопинг на сервере умирает напрочь
			  //КонецЕсли;  
			  
			  МожноЗаполнять=Не ЕстьБолееРанниеЗадания;
			  
			  
		  Иначе
			  МожноЗаполнять=Истина;
			  
		  КонецЕсли;	  
		  
	  КонецЦикла;
	  //---------------<>---------------------------// GtG // 12.04.2013 18:16:26
	  
	  Док.МО_ЗаполнитьОтчетКомиссионера(Док);
	  
	  ПараметрыСеанса.Беспредел=Истина;
	  
	  Успешно=Ложь;
	  Х=0;
	  Пока успешно<> Истина и  Х<=100 Цикл
		  Х=Х+1;
		  Попытка
			  Док.Записать(РежимЗаписиДокумента.Проведение);
			  Успешно=Истина;
		  Исключение
			  Успешно=Ложь;
			  ОбщегоНазначения.Задержка(2); // подождем 2 сек
		  КонецПопытки;
	  КонецЦикла;
	  ПараметрыСеанса.Беспредел=Ложь;

	
Конецпроцедуры	
	
	
	


Процедура РеализацияККМ_УдалениеОтчетаАптекиКомиссионераОбработкаУдаленияПроведения(Источник, Отказ) Экспорт
    
    ВОЗВРАТ;    // GtG  //  16.04.2014 15:05:49 ОТКЛЮЧЕНО!!!

    
    
    Если Источник.Склад.РаботаТолькоПоКомиссии =ложь ТОгда
		Возврат;
	КонецЕсли;	
	
	
	//Начинает работать с 01.01.2013
	Если Источник.Дата<Дата("20130101000000") тогда
		Возврат;
	КонецЕсли;	
	
	
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	ОтчетАптекиКомиссионера.Ссылка
	                    |ИЗ
	                    |	Документ.ОтчетАптекиКомиссионера КАК ОтчетАптекиКомиссионера
	                    |ГДЕ
	                    |	НАЧАЛОПЕРИОДА(ОтчетАптекиКомиссионера.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)
	                    |	И ОтчетАптекиКомиссионера.Склад = &Склад
	                    |	И ОтчетАптекиКомиссионера.СкладКомиссионер = &СкладКомиссионер");
	
	Запрос.УстановитьПараметр("Дата",Источник.Дата);
	Запрос.УстановитьПараметр("Склад",Источник.Склад.Комитент    );
	Запрос.УстановитьПараметр("СкладКомиссионер",Источник.Склад  );
	
	СписокУдаляемых=Запрос.Выполнить().Выгрузить();
	Если СписокУдаляемых.Количество()<>0 Тогда
		Для Каждого Стр Из СписокУдаляемых Цикл
			Стр.Ссылка.ПолучитьОбъект().Удалить();
		КонецЦикла;
	КонецЕсли;	
	
	
КонецПроцедуры

Процедура ОбнулениеКонтрольнойСуммыЗагруженногоДокументаПриЗаписи(Источник, Отказ) Экспорт
	// При загрузке документа из аптечного модуля ver.2 в регистр КонтрольныеСуммыАптечныхДокументов
	// пишется контрольная сумма. При повторной загрузке она сверяется с КС из файла и при расхождениях
	// в контрольных суммах документ перезаполняется по данным из аптеки.
	          
	//сообщить("ОбнулениеКонтрольнойСуммыЗагруженногоДокументаПриЗаписи");
	
	//Нз=РегистрыСведений.КонтрольныеСуммыАптечныхДокументов.СоздатьНаборЗаписей();
	//ОтборПоДокументу=Нз.Отбор.Найти("Объект");
	//ОтборПоДокументу.Установить(Источник.ссылка,Истина);
	//
	//НЗ.Прочитать();
	//
	//Если НЗ.Количество()=0 Тогда
	//	Возврат; // данные об этом документе из аптеки не приходили и в офисе его не создавали.
	//КонецЕсли;	
	//
	//Если Нз[0].КонтрольнаяСумма<>0 тогда
	//	Нз[0].КонтрольнаяСумма=0;
	//	НЗ.Записать();
	//КонецЕсли;
	//---------------<Извещение аптеки об изменении состояния документа>---------------------------// GtG // 24.06.2013 18:21:58
	// в регистр ИзвещениеАптекиОбИзмененииСостоянияДокументов пишем строку о состоянии документа
		
	
	
	
	
	
	
КонецПроцедуры

Процедура СозданиеЗаписиВРеестреДокументов(Источник, Отказ) Экспорт
	// Вставить содержимое обработчика.
	    //сообщить("СозданиеКонтрольнойСуммыПоДокументамИзОфисаПриЗаписи");
		
	    //ДлинаНомераДокумента=Источник.Метаданные().ДлинаНомера;
		//Запрос=Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		//                    |	НастройкаЗагрузкиИз_АМ2.DOCTYPE
		//                    |ИЗ
		//                    |	РегистрСведений.НастройкаЗагрузкиИз_АМ2 КАК НастройкаЗагрузкиИз_АМ2
		//                    |ГДЕ
		//                    |	НастройкаЗагрузкиИз_АМ2.МД = &МД");
		//Запрос.УстановитьПараметр("МД",Источник.Метаданные().Имя);					
		//Рез=Запрос.Выполнить().Выгрузить();
		//Если Рез.Количество()=0 Тогда // нет настроек - нет обмена
		//	Возврат;
		//КонецЕсли;	
		//ТипДокумента=Рез.Получить(0).DocType;
		//
		//СтруктураАидов = Обмен.СоздатьЗаписьВРеестре(Источник.Ссылка,ТипДокумента);
		//
		//
		//МЗ=РегистрыСведений.ИзвещениеАптекиОбИзмененииСостоянияДокументов.СоздатьМенеджерЗаписи();
		//МЗ.AIDEXT=СтруктураАидов.НашАид;
		//МЗ.DocType=ТипДокумента;
		//МЗ.Объект=Источник.Ссылка;
		//
		//МЗ.Прочитать();
		//
		//МЗ.AID		=СтруктураАидов.ВнешнийАид;
		//МЗ.AIDEXT	=СтруктураАидов.НашАид;
		//МЗ.DocType	=ТипДокумента;
		//МЗ.Объект	=Источник.Ссылка;

		//
		//
		//МЗ.is_posting=Формат(Источник.Проведен,"БЛ=0; БИ=1");
		//МЗ.is_deleted=Формат(Источник.ПометкаУдаления,"БЛ=0; БИ=1");
		//
		//Если ТипЗнч(Источник)=Тип("ДокументОбъект.ВозвратТовараПоставщику")
		//	или
		//	ТипЗнч(Источник)=Тип("ДокументОбъект.Списание")
		//	или
		//	ТипЗнч(Источник)=Тип("ДокументОбъект.ПоступлениеТовара")
		//	
		//	ТОгда
		//	МЗ.sum_r_w_nds=Источник.СуммаДокРозн;
		//	МЗ.sum_z_w_nds=Источник.СуммаДок;
		//ИначеЕсли ТипЗнч(Источник)=Тип("ДокументОбъект.ПоступлениеТовара") 
		//		ТОгда
		//			МЗ.sum_r_w_nds=Источник.СуммаДокРозн;
		//			МЗ.sum_z_w_nds=Источник.СуммаДок;
		//Иначе
		//	МЗ.sum_r_w_nds=0;
		//	МЗ.sum_z_w_nds=0;
		//	
		//КонецЕсли;	
		//
		//МЗ.Аптека=Источник.Склад;
		//
		//
		//МЗ.Записать();
		//
		
КонецПроцедуры

Процедура АВЕКОНС_ПриЗаписиСправочникаМестаХраненияПриЗаписи(Источник, Отказ) Экспорт
	//Добавляет/обновляет склад в базе консолидации АВЕ. через её вебсервис.
	//ЗаписьЖурналаРегистрации("МХ->WS->АВЕ_КОНС",,Источник.ссылка,Источник,"Начинаем выгрузку...",);
	//Попытка // если вдруг лег вебсервис
	//	
	//	АдресWSDL="http://10.250.205.11:8080/ave_cons/ws/ave_cons_indatasync.1cws?wsdl";       //Например "http://bebebe.com:8080/bebe_bubu/ws/buh_exchange.1cws?wsdl";
	//	TargetNamespace="AVE_CONS_INDataSync.ORG"; //Например "http://localhost/bebe_bubu" из первой строки WSDL  targetNamespace="http://localhost/bebe_bubu"
	//	DefinitionsName="AVE_CONS_INDataSync"; //Например "buh_exchange" из первой строки WSDL definitions name="buh_exchange"
	//	PortName="AVE_CONS_INDataSyncSoap12";        //Например   "buh_exchangeSoap12"  в конце WSDL port name="buh_exchangeSoap12" binding="tns:buh_exchangeSoap12Binding">
	//	
	//	
	//	Определение=Новый WSОпределения(СокрЛП(АдресWSDL));
	//	
	//	Прокси = Новый WSПрокси(Определение,
	//	СокрЛП(TargetNamespace),//targetNamespace из WSDL
	//	СокрЛП(DefinitionsName),//definitions name из  WSDL 
	//	СокрЛП(PortName),       // port name из WSDL 
	//	0);
	//	
	//	
	//	Спр=Источник;
	//	ТипСклад=Прокси.ФабрикаXDTO.Тип("AVE_CONS_INDataSync.ORG","Store");
	//	
	//	Склад=Прокси.ФабрикаXDTO.Создать(ТипСклад);
	//	
	//	Склад.code   =Спр.Код;
	//	Склад.org_inn=Спр.Фирма.Инн;
	//	Склад.name   =Спр.Наименование;
	//	Склад.delmark=Спр.ПометкаУдаления;
	//	
	//	Результат=Прокси.CreateUpdate_Store(Склад);
	//	
	//	ЗаписьЖурналаРегистрации("МХ->WS->АВЕ_КОНС",,Источник.ссылка,Источник,Результат,);
	//	
	//исключение
	//	// ну нет так нет
	//	
	//	ЗаписьЖурналаРегистрации("МХ->WS->АВЕ_КОНС",,Источник.ссылка,Источник,ОписаниеОшибки(),);
	//КонецПопытки;
	
	
КонецПроцедуры

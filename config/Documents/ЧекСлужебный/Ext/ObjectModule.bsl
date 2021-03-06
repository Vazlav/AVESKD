﻿Перем ECR;	


Процедура ОтметитьЗакрытиеСменыВЧеках() экспорт
	
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	ЧекПродажи.Ссылка
	                    |ИЗ
	                    |	Документ.ЧекПродажи КАК ЧекПродажи
	                    |ГДЕ
	                    |	ЧекПродажи.ДатаСмены = &ДатаСмены
	                    |	И ЧекПродажи.НомерСмены = &НомерСмены
	                    |	И ЧекПродажи.СерийныйНомер = &СерийныйНомер
	                    |	И ЧекПродажи.ЧекПробитНаККМ = ИСТИНА
	                    |	И ЧекПродажи.Проведен = ИСТИНА
	                    |	И ЧекПродажи.СменаЗакрыта = ЛОЖЬ
	                    |
	                    |ОБЪЕДИНИТЬ ВСЕ
	                    |
	                    |ВЫБРАТЬ
	                    |	ЧекВозврата.Ссылка
	                    |ИЗ
	                    |	Документ.ЧекВозврата КАК ЧекВозврата
	                    |ГДЕ
	                    |	ЧекВозврата.ДатаСмены = &ДатаСмены
	                    |	И ЧекВозврата.НомерСмены = &НомерСмены
	                    |	И ЧекВозврата.СерийныйНомер = &СерийныйНомер
	                    |	И ЧекВозврата.ЧекПробитНаККМ = ИСТИНА
	                    |	И ЧекВозврата.Проведен = ИСТИНА
	                    |	И ЧекВозврата.СменаЗакрыта = ЛОЖЬ");
						
	Запрос.УстановитьПараметр("ДатаСмены",ДатаСмены);
	Запрос.УстановитьПараметр("НомерСмены",НомерСмены);
	Запрос.УстановитьПараметр("СерийныйНомер",СерийныйНомер);
	
	ЗакрываемыеЧеки=Запрос.Выполнить().Выгрузить();
	
	Для Каждого Стр Из ЗакрываемыеЧеки Цикл
		ТекЧек=Стр.Ссылка.ПолучитьОбъект();
		ТекЧек.СменаЗакрыта=Истина;
		ТекЧек.Записать(РежимЗаписиДокумента.Запись);
	КонецЦикла;
	
	
	
	
КонецПроцедуры	
	


Процедура ОбработкаПроведения(Отказ, РежимПроведения)




Попытка
		ЗагрузитьВнешнююКомпоненту("C:\Program Files (x86)\1cv82\common\DLL\FPRNM1C.dll");
		ECR = Новый("AddIn.FprnM45");
		СостояниеККМ="ККМ:Подключена";
	исключение
		ECR=Неопределено;
		#Если   Клиент Тогда
		Предупреждение("Ошибка загрузки внешней компоненты C:\Program Files (x86)\1cv82\common\DLL\FPRNM1C.dll, ПЕЧАТЬ ЧЕКОВ НЕВОЗМОЖНА!!!");
		#Конецесли 
		СостояниеККМ="ККМ:НЕ ПОДКЛЮЧЕНА!!!";
		Отказ=Истина; Пробит=Ложь;  Возврат;

	конецпопытки;
	
	
	
	ECR.DeviceEnabled = 1;
	КодОшибки=ECR.ResultCode ;
	Если КодОшибки<> 0 тогда
		#Если   Клиент Тогда
		Предупреждение("ОШИБКА фискального регистратора! Код ошибки "+КодОшибки);
		#Конецесли 
		Отказ=Истина; Пробит=Ложь;  Возврат;

	КонецЕсли;

	// получаем состояние ККМ
	ГетСтатус=ECR.GetStatus() ;
	Если  ГетСтатус<> 0 тогда
		#Если   Клиент Тогда
		Предупреждение("ОШИБКА! Состояние ККМ "+ ГетСтатус);
		#Конецесли 
		Отказ=Истина; Пробит=Ложь;  Возврат;

	КонецЕсли;
		
		// если есть открытый чек, то отменяем его
	  Если ECR.CheckState <> 0 тогда
		  Если ECR.CancelCheck() <> 0 тогда
			#Если   Клиент Тогда
			ПРедупреждение("На ККМ был открытый чек и не удалось его отменить!");
			#Конецесли
			Отказ=Истина; Пробит=Ложь;  Возврат;

	    КонецЕсли;
	  КонецЕсли;

	
	
	Если ТипСлужебногоЧека=Перечисления.ККМ_ТипыСлужебныхЧеков.ОткрытиеСмены Тогда
		Если ECR.SessionOpened = 1 тогда
			#Если   Клиент Тогда
			ПРедупреждение("Смена уже открыта!");
			#Конецесли 
			Отказ=Истина; Пробит=Ложь;  Возврат;

		КонецЕсли;	
		
		// устанавливаем пароль системного администратора ККМ
			 ECR.Password = "30";
			 // входим в режим регистратции
			 ECR.Mode = 1;
			 КодОшибки=ECR.SetMode();
			 Если КодОшибки <> 0 тогда
				 #Если   Клиент Тогда
				 Предупреждение("Не удалось войти в режим регистрации! Код ошибки "+КодОшибки);
				 #Конецесли 
				 Отказ=Истина; Пробит=Ложь;  Возврат;

			 КонецЕсли;

		
		
		
		
		ECR.Password = "30";
		ECR.Caption="Открытие смены "+ТекущаяДата();
		
		РезОткрытия=ECR.OpenSession();
		
		Если РезОткрытия<>0 тогда
			#Если   Клиент Тогда
			Предупреждение("Ошибка открытия смены ! Код ошибки "+РезОткрытия);
			#Конецесли 
			Отказ=Истина; Пробит=Ложь;  Возврат;

		КонецЕсли;	
		
	ИначеЕсли ТипСлужебногоЧека=Перечисления.ККМ_ТипыСлужебныхЧеков.ВнесениеДенег Тогда
		
		Если ECR.SessionOpened = 1 тогда
			
			
			// Войти в режим регистрации
			ECR.Password = 30;
			ECR.Mode = 1;
			КодОшибки=ECR.SetMode();
			
			Если КодОшибки<>0 Тогда
				#Если   Клиент Тогда
				ПРедупреждение("Не удалось войти в режим регистрации! Код ошибки ККМ "+КодОшибки);
				#Конецесли 
				Отказ=Истина; Пробит=Ложь;  Возврат;
			КонецЕсли;
			// Внесение
			ECR.Summ = Сумма; // Сумма внесения
			КодОшибки=ECR.CashIncome(); // Выполнить внесение
			
			Если КодОшибки<>0 Тогда
				#Если   Клиент Тогда
				ПРедупреждение("Ошибка при внесении денег! Код ошибки ККМ "+КодОшибки);
				#Конецесли 
				Отказ=Истина; Пробит=Ложь;  Возврат;
			КонецЕсли;
			
		Иначе
			#Если   Клиент Тогда
			Предупреждение("Смена не открыта!");
			#Конецесли 
			Отказ=Истина; Пробит=Ложь;  Возврат; 
		КонецЕсли;

		
		
		
	ИначеЕсли ТипСлужебногоЧека=Перечисления.ККМ_ТипыСлужебныхЧеков.ВыплатаДенег Тогда
		  		Если ECR.SessionOpened = 1 тогда
			
			
			// Войти в режим регистрации
			ECR.Password = 30;
			ECR.Mode = 1;
			КодОшибки=ECR.SetMode();
			
			Если КодОшибки<>0 Тогда
				#Если   Клиент Тогда
				ПРедупреждение("Не удалось войти в режим регистрации! Код ошибки ККМ "+КодОшибки);
				#Конецесли 

				Отказ=Истина; Пробит=Ложь;  Возврат;
			КонецЕсли;
			// Внесение
			ECR.Summ = Сумма; // Сумма внесения
			КодОшибки=ECR.CashOutcome(); // Выполнить внесение
			
			Если КодОшибки<>0 Тогда
				
				Если КодОшибки=-3800 Тогда
					ТекстОшибки="Не достаточно денег в кассе для выплаты!";
				иначе	
					ТекстОшибки="Ошибка при выплате! Код ошибки ККМ "+КодОшибки;
				КонецЕсли;	
				
				#Если   Клиент Тогда
				ПРедупреждение(ТекстОшибки);
				#Конецесли 
				Отказ=Истина; Пробит=Ложь;  Возврат;
			КонецЕсли;
			
		Иначе
			#Если   Клиент Тогда
			Предупреждение("Смена не открыта!");
			#Конецесли 
			Отказ=Истина; Пробит=Ложь;  Возврат; 
		КонецЕсли;


		
	ИначеЕсли ТипСлужебногоЧека=Перечисления.ККМ_ТипыСлужебныхЧеков.X_Отчет Тогда
		   // если смена открыта снимаем Z-отчет
		 Если ECR.SessionOpened = 1 тогда
			 // устанавливаем пароль системного администратора ККМ
			 ECR.Password = "30";
			 // входим в режим отчетов без гашения
			 ECR.Mode = 2;
			 КодОшибки=ECR.SetMode();
			 Если КодОшибки <> 0 тогда
				 
				 #Если   Клиент Тогда
				 Предупреждение("Не удалось войти в режим отчетов без гашения ! Код ошибки "+КодОшибки);
				 #Конецесли 
				 Отказ=Истина; Пробит=Ложь;  Возврат;

			 КонецЕсли;
			 // снимаем отчет
			 ECR.ReportType = 2;
			 КодОшибки=ECR.Report() ;
			 Если КодОшибки<> 0 тогда
				 #Если   Клиент Тогда
				 Предупреждение("Не удалось снять X-отчет! Код ошибки ККМ "+КодОшибки); 
				 #Конецесли 
				 Отказ=Истина; Пробит=Ложь;  Возврат;
			 КонецЕсли;
		 Иначе
			 #Если   Клиент Тогда
			Предупреждение("Смена не открыта!");
			#Конецесли 
				 Отказ=Истина; Пробит=Ложь;  Возврат; 
		 КонецЕсли;

		
	ИначеЕсли ТипСлужебногоЧека=Перечисления.ККМ_ТипыСлужебныхЧеков.ОтчетПоСекциям Тогда
		Если ECR.SessionOpened = 1 тогда
			// устанавливаем пароль системного администратора ККМ
			ECR.Password = "30";
			// входим в режим отчетов  без гашения
			ECR.Mode = 2;
			Если ECR.SetMode() <> 0 тогда
				Отказ=Истина; Пробит=Ложь;  Возврат;
			КонецЕсли;
			// снимаем отчет
			ECR.ReportType = 7;
			КодОшибки=ECR.Report() ;
			Если КодОшибки<> 0 тогда
				#Если   Клиент Тогда
				Предупреждение("Не удалось снять Отчет по секциям! Код ошибки ККМ "+КодОшибки); 
				#Конецесли 
				Отказ=Истина; Пробит=Ложь;  Возврат;
			КонецЕсли;
		Иначе
			#Если   Клиент Тогда
			Предупреждение("Смена не открыта!");
			#Конецесли 
			Отказ=Истина; Пробит=Ложь;  Возврат; 
			
		КонецЕсли;
		
		
		
	ИначеЕсли ТипСлужебногоЧека=Перечисления.ККМ_ТипыСлужебныхЧеков.Z_Отчет  Тогда
		 // если смена открыта снимаем Z-отчет
		 Если ECR.SessionOpened = 1 тогда
			 // устанавливаем пароль системного администратора ККМ
			 ECR.Password = "30";
			 // входим в режим отчетов с гашением
			 ECR.Mode = 3;
			 КодОшибки =ECR.SetMode();
			 Если КодОшибки<> 0 тогда
				 #Если   Клиент Тогда
				 Предупреждение("Не войти в режим снятия отчета с гашением! Код ошибки ККМ "+КодОшибки); 
				 #Конецесли 
				 Отказ=Истина; Пробит=Ложь;  Возврат;
				 
			 КонецЕсли;
			 // снимаем отчет
			 ECR.ReportType = 1;
			 КодОшибки=ECR.Report() ;
			 Если КодОшибки<> 0 тогда
				 #Если   Клиент Тогда
				 Предупреждение("Не удалось снять Z-отчет! Код ошибки ККМ "+КодОшибки); 
				 #Конецесли 
				 Отказ=Истина; Пробит=Ложь;  Возврат;
			 КонецЕсли;
		 Иначе
			 #Если   Клиент Тогда
			 Предупреждение("Смена не открыта!");
			 #Конецесли 
			 Отказ=Истина; Пробит=Ложь;  Возврат; 
			 
		 КонецЕсли;
		 
		 
		//---------------<Если дошли до этого места значит Z-отчет вылез из ККМ>---------------------------// GtG // 01.08.2012 21:05:39 
		ОтметитьЗакрытиеСменыВЧеках();
		
		
	 КонецЕсли;
	
	
	
	
				
				
				
		
	
	
	
	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	 Пробит=Истина;
	 
	 Если ECR=Неопределено Тогда
		 #Если   Клиент Тогда
		 Предупреждение("Ошибка загрузки внешней компоненты C:\Program Files (x86)\1cv82\common\DLL\FPRNM1C.dll, ПЕЧАТЬ ЧЕКОВ НЕВОЗМОЖНА!!!");
		 #Конецесли 
		СостояниеККМ="ККМ:НЕ ПОДКЛЮЧЕНА!!!";
		Отказ=Истина; Пробит=Ложь;  Возврат;
     КонецЕсли;
	 
	 
	 ECR.RegisterNumber=19; // 19  === Режим работы ККМ,(Mode, AdvancedMode).,Номер текущего чека (CheckNumber), Состояние текущего чека(CheckState)
	                       //Сквозной номер документа (DocNumber). 
	ECR.GetRegister();
	
	НомерДокумента=ECR.DocNumber;
	
	ECR.RegisterNumber=22; //22 Заводской номер ККМ (SerialNumber).
	ECR.GetRegister();
	СерийныйНомер=ECR.SerialNumber;
	
	ECR.RegisterNumber=21; //21 Номер смены (Session):
	ECR.GetRegister();
	НомерСмены=ECR.Session;
	
	ДатаСмены=ТекущаяДата();
 КонецПроцедуры



Попытка
	ЗагрузитьВнешнююКомпоненту("C:\Program Files (x86)\1cv82\common\DLL\FPRNM1C.dll");
	ECR = Новый("AddIn.FprnM45");
	
исключение
	ECR=Неопределено;
	
конецпопытки;

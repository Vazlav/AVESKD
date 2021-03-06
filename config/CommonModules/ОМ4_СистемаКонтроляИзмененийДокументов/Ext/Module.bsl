﻿//============================================================================ GtG ===
Функция ОМ4_РасчетКС(Стр,Х=1,Рез=0) Экспорт
    // Назначение:
	// Расчет контрольной суммы по строке текста
	// для циклического запуска передаем ненулевое Рез - ранее посчитанная сумма
    // Х - номер строки документа 
	//--------------------------------------------------------------------------------
	МодульКС= 10000000;
	КС=Рез;
	
	ДЛя Ы=1 По СтрДлина(Стр)Цикл
		КС=КС+ Цел(КодСимвола(Стр,Ы)*171*Х);
		Если КС>МодульКС Тогда
			КС= КС-МодульКС; // КС всегда меньше МодуляКС
		КонецЕсли;	
		
	КонецЦикла;	
     Возврат КС;
КонецФункции
//============================================================================ GtG ===

//============================================================================ GtG ===
Функция ОМ4_РасчетКонтрольнойСуммыШапкиДокумента(Док) Экспорт
    // Назначение:
	// Расчитывает контрольную сумму шапки документа
	// Число
    // 
	//--------------------------------------------------------------------------------
	Возврат 0;   // !!!!!!!!!!!!!!  ОТКЛЮЧЕНО !!!!!!!!!!!!!!

	Рез=0;
	Х=1;	
	Для каждого Рекв Из Док.Метаданные().Реквизиты Цикл
		ИмяРекв=Рекв.имя;
		Х=Х+2;
		Рез=ОМ4_РасчетКС(Вычислить("Док."+ИмяРекв),Х,Рез);
	КонецЦикла; 
	Х=Х+2;
	Рез=ОМ4_РасчетКС(Док.Номер,Х,Рез);	
	Х=Х+2;
	Рез=ОМ4_РасчетКС(Док.Дата,Х,Рез);
	
	Если Док.Проведен Тогда
		Рез=ОМ4_РасчетКС(Док.Дата,7,Рез*7);
	Иначе
       //Рез=Рез*1;
	КонецЕсли;	
	
	Возврат Рез;
КонецФункции
//============================================================================ GtG ===

//============================================================================ GtG ===
Функция ОМ4_РасчетКонтрольнойСуммыТабЧастиДокумента(ТЧ) Экспорт
    // Назначение:
	// Расчитывает контрольную сумму ТабличнойЧасти (переданной в параметре ТЧ) документа
	// Число
    // 
	//--------------------------------------------------------------------------------
	Возврат 0;   // !!!!!!!!!!!!!!  ОТКЛЮЧЕНО !!!!!!!!!!!!!!

	
	Рез=0; // Пустая ТЧ
    Х=1;
	Для Ы=0 По ТЧ.Количество()-1 цикл
	    СтрТЧ=ТЧ.Получить(Ы); 
		Х=Х+2;// всегда нечетное число
		Стр=" ";
		Для каждого ЗначКолонки Из СтрТч Цикл
            	Стр=Стр+СокрЛП(ЗначКолонки);
		КонецЦикла; 
			
		Рез=ОМ4_РасчетКС(Стр,Х,Рез);
	КонецЦикла; 
     Возврат Рез;
КонецФункции
//============================================================================ GtG ===


#Если Клиент Тогда
ПРоцедура ОМ4_ПередЗаписью(ТекДок,КонтролируемаяТЧ,КонтрольнаяСуммаШапкиИсходногоДокументаПередОткрытием ,КонтрольнаяСуммаТЧИсходногоДокументаПередОткрытием,КомментИзвне="",ТолькоШ=Ложь,ТолькоТ=Ложь) Экспорт
	Если ТекДок.ЭтоНовый()=Ложь Тогда
		Если  ТекДок.Модифицированность()=Истина ТОгда
			//----------------------------< Определяем что изменилось по контрольным суммам >--------------------------------GtG--- 
			КонтрольнаяСуммаШапкиИзмененного=0;//ОМ4_РасчетКонтрольнойСуммыШапкиДокумента(ТекДок.ЭтотОбъект);
			КонтрольнаяСуммаТЧИзмененного=0;//ОМ4_РасчетКонтрольнойСуммыТабЧастиДокумента(КонтролируемаяТЧ);
			
			Если КонтрольнаяСуммаШапкиИзмененного<>КонтрольнаяСуммаШапкиИсходногоДокументаПередОткрытием
				или
				КонтрольнаяСуммаТЧИзмененного<>КонтрольнаяСуммаТЧИсходногоДокументаПередОткрытием тогда
				
				//Сообщить("Документ был изменен!");
								
				
				ИШ=0; ИТ=0;
				
				Если КонтрольнаяСуммаШапкиИзмененного<>КонтрольнаяСуммаШапкиИсходногоДокументаПередОткрытием Тогда
					ИШ=1;
				КонецЕсли; 	
				
				Если КонтрольнаяСуммаТЧИзмененного<>КонтрольнаяСуммаТЧИсходногоДокументаПередОткрытием Тогда
					ИТ=1;
				КонецЕсли;
				
				
				
				Если (ИШ=1) И (ИТ=1) Тогда
					Изменение=Перечисления.ДействияНадДокументами.ИзмТабИШапка;
				ИначеЕсли ИШ=1 ТОгда
					Если ТолькоТ=Истина тогда
						ВОЗВРАТ ; // в данном случае интересует только изменение табличной части
					КонецЕсли;	
					Изменение=Перечисления.ДействияНадДокументами.ИзмШапка;
				ИначеЕсли ИТ=1 Тогда
					Если ТолькоШ=Истина  тогда
						ВОЗВРАТ ; // в данном случае интересует только изменение шапки, а она не менялась
					КонецЕсли;	
					Изменение=Перечисления.ДействияНадДокументами.ИзмТабЧасть;
				КонецЕсли; 
				//----------------------------< запишем для разбора полетов  >--------------------------------GtG---
				
				
				СтрИзм=ТекДок.Изменения.Добавить();
				СтрИзм.Дата=ТекущаяДата();
				СтрИзм.Сотрудник=ПараметрыСеанса.ТекущийСотр;
                СтрИзм.ТипИзм=Изменение;
				
				
				
				Коммент="";
				Пока Коммент="" Цикл
					ВвестиСтроку(Коммент,"ПОЧЕМУ ИЗМЕНЕН ДОКУМЕНТ? "+КомментИзвне,300, ЛОЖЬ);
				КонецЦикла; 
				
				СтрИзм.КомментарийИзменения=""+КомментИзвне+"  "+Коммент;
				
			КонецЕсли;
		КонецЕсли; 	
	КонецЕсли; 	
КонецПроцедуры
#КонецЕсли
#Если Клиент Тогда
Процедура ОМ4_ПРиОткрытии(ТекДок,КонтролируемаяТЧ,КонтрольнаяСуммаШапкиИсходногоДокументаПередОткрытием,КонтрольнаяСуммаТЧИсходногоДокументаПередОткрытием,комментарийИзвне="") Экспорт
	Если ТекДок.ЭтоНовый()=Истина Тогда
		НоваяСтрокаИзм = ТекДок.Изменения.Добавить();
		НоваяСтрокаИзм.Дата=ТекущаяДата();
		НоваяСтрокаИзм.Сотрудник=ПараметрыСеанса.ТекущийСотр;
		НоваяСтрокаИзм.ТипИзм=Перечисления.ДействияНадДокументами.ВводНового;
		
		КонтрольнаяСуммаШапкиИсходногоДокументаПередОткрытием=0;
		КонтрольнаяСуммаТЧИсходногоДокументаПередОткрытием=0;
		
	Иначе
		//КонтрольнаяСуммаШапкиИсходногоДокументаПередОткрытием=ОМ4_РасчетКонтрольнойСуммыШапкиДокумента(ТекДок.ЭтотОбъект);
		//КонтрольнаяСуммаТЧИсходногоДокументаПередОткрытием=ОМ4_РасчетКонтрольнойСуммыТабЧастиДокумента(КонтролируемаяТЧ);
	КонецЕсли;
КонецПроцедуры	
#КонецЕсли

Процедура ЗаписатьДействияВИсториюДокумента(Изменения,РежимЗаписи,ПометкаУдаления,ФиксироватьОбычнуюЗапись=Ложь)  Экспорт
	
	Если ПометкаУдаления = Истина Тогда
		стрИзм = Изменения.Добавить();
		стрИзм.Дата = ТекущаяДата();
		стрИзм.Сотрудник = ПараметрыСеанса.ТекущийСотр;
		стрИзм.ТипИзм = Перечисления.ДействияНадДокументами.Изменение;
		стрИзм.КомментарийИзменения = "Помечен на удаление";			
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		стрИзм = Изменения.Добавить();
		стрИзм.Дата = ТекущаяДата();
		стрИзм.Сотрудник = ПараметрыСеанса.ТекущийСотр;
		стрИзм.ТипИзм = Перечисления.ДействияНадДокументами.Изменение;
		стрИзм.КомментарийИзменения = "Проведен";	
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда		
		стрИзм = Изменения.Добавить();
		стрИзм.Дата = ТекущаяДата();
		стрИзм.Сотрудник = ПараметрыСеанса.ТекущийСотр;
		стрИзм.ТипИзм = Перечисления.ДействияНадДокументами.ОтменаПроведения;
		стрИзм.КомментарийИзменения = "Отмена проведения";
	Иначе //Если РежимЗаписи = РежимЗаписиДокумента.Запись Тогда		
		Если ФиксироватьОбычнуюЗапись Тогда
			стрИзм = Изменения.Добавить();
			стрИзм.Дата = ТекущаяДата();
			стрИзм.Сотрудник = ПараметрыСеанса.ТекущийСотр;
			стрИзм.ТипИзм = Перечисления.ДействияНадДокументами.Изменение;
			стрИзм.КомментарийИзменения = "Записан";
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

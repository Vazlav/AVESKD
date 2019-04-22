﻿ //============================================================================ GtG ===
 Функция ПроверкаНаНули  (Парам) 
     // Назначение:
 	// Проверяет строки товара на наличие строк с нулевыми значениями
 	// 
     // 
 	//--------------------------------------------------------------------------------
	Для Каждого ТекСтрокаТовар Из Товар Цикл
		Если ТекСтрокаТовар[Парам]=0 Тогда
			Возврат ЛОЖЬ;
		КонецЕсли;
	КонецЦикла; 	
	
	Возврат Истина;
 КонецФункции
 //============================================================================ GtG ===
 
 
 //============================================================================ GtG ===
 Процедура ПриходРасходПоРегистрам  (ТипДвижения) 
	 // Назначение:
	 // Проведение документа по регистрам 
	 // либо приход , ибо расход
	 // по указанному складу
	 //--------------------------------------------------------------------------------
	 
	 Для Каждого ТекСтрокаТовар Из Товар Цикл
		 
		 Если Поставщик <> ТекСтрокаТовар.Партия.Поставщик Тогда
			 Сообщить("по товару: " + ТекСтрокаТовар.Товар + " строка № " + ТекСтрокаТовар.НомерСтроки + " не соответствует поставщик выбранному");
		КонецЕсли;
		 //----------------------------< Партионные товары (ЖНВЛС/СВЛС) >--------------------------------GtG---
		 
		 ДвижениеП = Движения.ПартииЖНВЛС.Добавить();
		 ДвижениеП.ВидДвижения=ТипДвижения; //ВидДвиженияНакопления.Приход;
		 ДвижениеП.Период = Дата;
		 ДвижениеП.Товар = ТекСтрокаТовар.Товар;
		 ДвижениеП.Склад = Склад;
		 ДвижениеП.СтавкаНДС = ТекСтрокаТовар.СтавкаНДС;
		 ДвижениеП.Партия = ТекСтрокаТовар.Партия ;
		 ДвижениеП.Фирма= Склад.Фирма;
		 ДвижениеП.ВидОперации=Перечисления.ВидыОпераций.СписаниеТМЦ;
		 
		 
		 ДвижениеП.Колво = ТекСтрокаТовар.КоличествоФакт*ТекСтрокаТовар.Коэфф;
		 ДвижениеП.СуммаЗакупСНДС = ТекСтрокаТовар.СуммаЗакуп;
		 ДвижениеП.СуммаНДСЗакуп = ТекСтрокаТовар.НДСЗакуп;
		 ДвижениеП.СуммаРознСНДС = ТекСтрокаТовар.СуммаРозн;
		 ДвижениеП.СуммаРознНДС = ТекСтрокаТовар.НДСРозн;
		 ЕстьПартионныеТовары=Истина;
		 
		 
	 КонецЦикла;
	 // записываем движения регистров
	 
	 //Движения.ПартииЖНВЛС.Записать();
	 
	 
	 //----------------------------< По регитсру учета по ставке НДС >--------------------------------GtG---
	 ТЗПодСвертку = ТОвар.Выгрузить();
	 
	 ТЗПодСвертку.Свернуть("СтавкаНДС","СуммаЗакуп,НДСЗакуп,СуммаРозн,НДСРозн");
	 
	 Для Каждого ТекСтрокаТовар Из ТЗПодСвертку Цикл
		 // регистр ОстаткиПоСтНДСПоСкладам Приход
		 Движение = Движения.ОстаткиПоСтНДСПоСкладам.Добавить();
		 Движение.ВидДвижения =ТипДвижения;// ВидДвиженияНакопления.Приход;
		 Движение.Период = Дата;
		 Движение.Склад = Склад;
		 Движение.СтавкаНДС = ТекСтрокаТовар.СтавкаНДС;
		 Движение.Фирма= Склад.Фирма;
		 Движение.ВидОперации=Перечисления.ВидыОпераций.СписаниеТМЦ;
		 // Суммы строк документа 
		 Движение.СуммаЗакупСНДС = ТекСтрокаТовар.СуммаЗакуп;
		 Движение.СуммаНДСЗакуп = ТекСтрокаТовар.НДСЗакуп;
		 Движение.СуммаРознСНДС = ТекСтрокаТовар.СуммаРозн;
		 Движение.СуммаРознНДС = ТекСтрокаТовар.НДСРозн;
	 КонецЦикла;
	 // записываем движения регистров
	 //Движения.ОстаткиПоСтНДСПоСкладам.Записать();
	 
  КонецПроцедуры
  //============================================================================ GtG ===
  
Функция ПроверитьОстатки()
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ВнутреннийВозвратТовары.Товар КАК Номенклатура,
	               |	ВнутреннийВозвратТовары.Партия КАК Партия,
	               |	СУММА(ВнутреннийВозвратТовары.КоличествоФакт * ВнутреннийВозвратТовары.Коэфф) КАК КоличествоСписываемое
	               |ПОМЕСТИТЬ Выборка
	               |ИЗ
	               |	Документ.ВозвратТовараПоставщику.Товар КАК ВнутреннийВозвратТовары
	               |ГДЕ
	               |	ВнутреннийВозвратТовары.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВнутреннийВозвратТовары.Товар,
	               |	ВнутреннийВозвратТовары.Партия
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Выборка.Номенклатура,
	               |	Выборка.Партия КАК Партия,
	               |	Выборка.КоличествоСписываемое,
	               |	Остатки.КолвоОстаток
	               |ИЗ
	               |	Выборка КАК Выборка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииЖНВЛС.Остатки(
	               |				&МоментВремениДокумента,
	               |				Товар В
	               |						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |							Выборка.Номенклатура
	               |						ИЗ
	               |							Выборка)
	               |					И Склад = &ВыбСклад
	               |					И Партия В
	               |						(ВЫБРАТЬ
	               |							Выборка.Партия
	               |						ИЗ
	               |							Выборка)) КАК Остатки
	               |		ПО Выборка.Номенклатура = Остатки.Товар
	               |			И Выборка.Партия = Остатки.Партия
	               |ГДЕ
	               |	Выборка.КоличествоСписываемое > Остатки.КолвоОстаток
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ Выборка";
	
	Запрос = Новый  Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.УстановитьПараметр("МоментВремениДокумента",МоментВремени());
	Запрос.УстановитьПараметр("ВыбСклад",Склад);
	Рез=Запрос.Выполнить();
	ТЗ=Рез.Выгрузить();	
	Если ТЗ.Количество() > 0 Тогда
		Для каждого стр Из ТЗ Цикл
			Сообщить("По товару " + стр.Номенклатура + "  партия = " + стр.Партия + " превышено количество .");
		КонецЦикла; 	
		Возврат Ложь;
	КонецЕсли;
	
    Возврат Истина;
		
КонецФункции

Процедура СоздатьДокументыДляВозвратаКомиссии()  Экспорт
	ТХТ= "ВЫБРАТЬ
	     |	ВозвратСКомиссии.Ссылка
	     |ИЗ
	     |	Документ.ВозвратСКомиссии КАК ВозвратСКомиссии
	     |ГДЕ
	     |	ВозвратСКомиссии.ДокОснование = &ДокОснование";
	Запрос = Новый Запрос;
	Запрос.Текст = ТХТ;
	Запрос.УстановитьПараметр("ДокОснование",Ссылка);
	Рез = Запрос.Выполнить();
	Если НЕ Рез.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ПерваяСтрока = Товар.Получить(0);
	НовыйДок = Документы.ВозвратСКомиссии.СоздатьДокумент();
	НовыйДок.Дата = Дата;
	НовыйДок.СкладКомиссионер = Склад;
	НовыйДок.ФирмаКомиссионер = Фирма;
	НовыйДок.Склад			  = Склад.Комитент;
	НовыйДок.Фирма			  = Склад.Комитент.Фирма;
	НовыйДок.СуммаДок		  = СуммаДок;
	НовыйДок.СуммаДокРозн	  = СуммаДокРозн;
	НовыйДок.ДокОснование	  = Ссылка;
	НовыйДок.Поставщик		  = ПерваяСтрока.Партия.ПартияРодитель.Поставщик;
	НовыйДок.ВхНомерНакл	  = ПерваяСтрока.НомДокПост;//Лев(ПерваяСтрока.НомДокПост,Найти(ПерваяСтрока.НомДокПост,"-(")-1);
	Для каждого стр из Товар Цикл
		ЗаполнитьЗначенияСвойств(НовыйДок.Товар.Добавить(),стр);
	КонецЦикла;
	НовыйДок.Записать(РежимЗаписиДокумента.Проведение);
	
	НовыйВозврат = Документы.ВозвратТовараПоставщику.СоздатьДокумент();
	НовыйВозврат.Дата = Дата;
	НовыйВозврат.Склад = Склад.Комитент;
	НовыйВозврат.Фирма = Склад.Комитент.Фирма;
	НовыйВозврат.СуммаДок = СуммаДок;
	НовыйВозврат.СуммаДокРозн = СуммаДокРозн;
	НовыйВозврат.НомДокАптеки = НомДокАптеки;
	НовыйВозврат.Поставщик	= НовыйДок.Поставщик;
	НовыйВозврат.ПоНакладной = НовыйДок.ВхНомерНакл;
	НовыйВозврат.СпособВозврата = СпособВозврата;
	
	Для каждого стр из Товар Цикл
		НоваяСтрока = НовыйВозврат.Товар.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,стр);
		НоваяСтрока.Партия = стр.Партия.ПартияРодитель;
		НоваяСтрока.НомДокПост = стр.Партия.ПартияРодитель.ДокументПоступления.ВхНомерНакл;
			
	КонецЦикла;
	
	
	НовыйВозврат.Записать(РежимЗаписиДокумента.Проведение);
	
	СпособВозврата = Перечисления.ВидыВозвратаПоставщику.ВозвратКомитенту;
	
КонецПроцедуры

Процедура УдалитьДокументВозвратаКомиссии()
	
	ТХТ= "ВЫБРАТЬ
	     |	ВозвратСКомиссии.Ссылка
	     |ИЗ
	     |	Документ.ВозвратСКомиссии КАК ВозвратСКомиссии
	     |ГДЕ
	     |	ВозвратСКомиссии.ДокОснование = &ДокОснование";
	Запрос = Новый Запрос;
	Запрос.Текст = ТХТ;
	Запрос.УстановитьПараметр("ДокОснование",Ссылка);
	Рез = Запрос.Выполнить();
	Если НЕ Рез.Пустой() Тогда
		Выборка = Рез.Выбрать();
		Выборка.Следующий();
		ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Для н=0 по 3 Цикл
			Попытка
				ДокОбъект.УстановитьПометкуУдаления(Истина);
				Прервать;
			Исключение
				ОбщегоНазначения.Задержка(2);
			КонецПопытки;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры
  
Процедура ОбработкаПроведения(Отказ, Режим)
	

	ЕстьПартионныеТовары= ЛОЖЬ;
	
		
	#Если Клиент Тогда
	ОчиститьСообщения(); 
	#КонецЕсли
	

	
	//============================< Проверка на коэфф=0  >================================GtG===
	Если ПроверкаНаНули("Коэфф")=Ложь Тогда
		// Есть строки с 0-ми коэффициентами
		Сообщить("В документе есть строки с коэффициентами =0!
		|Это недопустимо!
		|Очевидно проблемы с единицами товаров.");
		Отказ = ИСТИНА;
		ВОЗВРАТ ;
	КонецЕсли;
	
	Если ПроверкаНаНули("ЦенаЗакуп")=Ложь Тогда
		// Есть строки с 0-ми
		Сообщить("В документе есть строки без закуп. цены!
		|Это недопустимо!
		|Укажите цену закупочную!");
		Отказ = ИСТИНА;
		ВОЗВРАТ ;
	КонецЕсли;

	
		
	// расход из регистров: 
	//                    	ПартииЖНВЛС
	//                    	ОстаткиПоСтНДСПоСкладам
    ПриходРасходПоРегистрам(ВидДвиженияНакопления.Расход);                    
	//-------------------------------------------------------------------------------------------
	
	ОМ15_ОчисткаРезерваДокумента  (ЭтотОбъект.Ссылка );// должна быть во всех документах, которые касаются резерва количества товара
	
КонецПроцедуры

//==================<Перед удалением надо резерв очистить>===================Virus====26.11.2007
Процедура ПередУдалением(Отказ)
	
	 ОМ15_ОчисткаРезерваДокумента(ЭтотОбъект.Ссылка );// должна быть во всех документах, которые касаются резерва количества товара
	 
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОМ41_ПередУдалениемДокумента  (ЭтотОбъект,Отказ);
	Если Отказ = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если Товар.Количество()>0 Тогда
		ПерваяСтрока=ТОвар.Получить(0);
		Если ПерваяСтрока.Партия.Пустая()= Ложь Тогда
			ОМ15_ОчисткаРезерваДокумента( ЭтотОбъект.Ссылка );
			ОМ15_ДобавитьДокументЦеликомВРезервПодбора(ЭтотОбъект.Ссылка);
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТовара") Тогда
		// Заполнение шапки
		Комментарий = Основание.Комментарий;
		Поставщик = Основание.Поставщик;
		Склад = Основание.Склад;
		ДокОснование = Основание.Ссылка;
		СуммаДок = Основание.СуммаДок;
		Фирма = Основание.Фирма;
		Дата = ТекущаяДата();
		Для Каждого ТекСтрокаТовар Из Основание.Товар Цикл
			НоваяСтрока = Товар.Добавить();
			НоваяСтрока.ЕИТ = ТекСтрокаТовар.ЕИТ;
			НоваяСтрока.КоличествоФакт = ТекСтрокаТовар.КоличествоФакт;
			НоваяСтрока.Коэфф = ТекСтрокаТовар.Коэфф;
			НоваяСтрока.НДСЗакуп = ТекСтрокаТовар.НДСЗакуп;
			НоваяСтрока.НДСРозн = ТекСтрокаТовар.НДСРозн;
			НоваяСтрока.Партия = ТекСтрокаТовар.Партия;
			НоваяСтрока.ПроцентРознНац = ТекСтрокаТовар.ПроцентРознНац;
			НоваяСтрока.Серия = ТекСтрокаТовар.Серия;
			НоваяСтрока.Сертификат = ТекСтрокаТовар.Сертификат;
			НоваяСтрока.СтавкаНДС = ТекСтрокаТовар.СтавкаНДС;
			НоваяСтрока.СуммаЗакуп = ТекСтрокаТовар.СуммаЗакуп;
			НоваяСтрока.Товар = ТекСтрокаТовар.Товар;
			НоваяСтрока.ЦенаЗакуп = ТекСтрокаТовар.ЦенаЗакуп;
			НоваяСтрока.НомДокПост = СокрЛП(Основание.ВхНомерНакл);			
			Если Склад.ТипСклада = Перечисления.ТипыМХ.Опт Тогда
				НоваяСтрока.ЦенаРозн = ТекСтрокаТовар.ЦенаЗакуп;
				НоваяСтрока.СуммаРозн = ТекСтрокаТовар.СуммаЗакуп;
			Иначе
				НоваяСтрока.ЦенаРозн = ТекСтрокаТовар.ЦенаРозн;
				НоваяСтрока.СуммаРозн = ТекСтрокаТовар.СуммаРозн;
			КонецЕсли;
			
		КонецЦикла;
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПеремещениеТовара") Тогда
		// Заполнение шапки
		Дата = ТекущаяДата();
		Комментарий = Основание.Комментарий;
		Склад = Основание.Склад;
		ДокОснование = Основание.Ссылка;
		СпособВозврата = Перечисления.ВидыВозвратаПоставщику.ПриПриемке;
		СуммаДок = Основание.СуммаДок;
		СуммаДокРозн = Основание.СуммаДокРозн;
		Фирма = Склад.Фирма;
		Для Каждого ТекСтрокаТовар Из Основание.Товар Цикл
			НоваяСтрока = Товар.Добавить();
			НоваяСтрока.ЕИТ = ТекСтрокаТовар.ЕИТ;
			НоваяСтрока.КоличествоФакт = ТекСтрокаТовар.КоличествоФакт;
			НоваяСтрока.Коэфф = ТекСтрокаТовар.Коэфф;
			НоваяСтрока.НДСЗакуп = ТекСтрокаТовар.НДСЗакуп;
			НоваяСтрока.НДСРозн = ТекСтрокаТовар.НДСРознПол;
			НоваяСтрока.Партия = ТекСтрокаТовар.Партия;
			НоваяСтрока.ПроцентРознНац = ТекСтрокаТовар.ПроцентРознНацПол;
			НоваяСтрока.Серия = ТекСтрокаТовар.Серия;
			НоваяСтрока.Сертификат = ТекСтрокаТовар.Сертификат;
			НоваяСтрока.СтавкаНДС = ТекСтрокаТовар.СтавкаНДС;
			НоваяСтрока.СуммаЗакуп = ТекСтрокаТовар.СуммаЗакуп;
			НоваяСтрока.СуммаРозн = ТекСтрокаТовар.СуммаРознПол;
			НоваяСтрока.Товар = ТекСтрокаТовар.Товар;
			НоваяСтрока.ЦенаЗакуп = ТекСтрокаТовар.ЦенаЗакуп;
			НоваяСтрока.ЦенаРозн = ТекСтрокаТовар.ЦенаРознПол;
  			Если ТипЗнч(НоваяСтрока.Партия.ДокументПоступления) = Тип("ДокументСсылка.ПоступлениеТовара") Тогда
				НоваяСтрока.НомДокПост = СокрЛП(НоваяСтрока.Партия.ДокументПоступления.ВхНомерНакл);
			КонецЕсли;

		КонецЦикла;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	СуммаДок=Товар.Итог("СуммаЗакуп");
	СуммаДокРозн=Товар.Итог("СуммаРозн");	
	
	Если РежимЗаписи=РежимЗаписиДокумента.Проведение ТОгда
		//---------------<Во всех других режимах дает ошибку>---------------------------// GtG // 09.04.2013 13:58:18
		// В случае если пытаться распровести или записать без проведения документ на момент времени, когда на остатках нет 
		// како-го либо товара срабатывала лишняя проверка и неверно определялась ошибочная ситуация с отрицательным остатком.
		
		Если ПроверитьОстатки() = Ложь Тогда
			Сообщить("Документ не проведен!");
			Отказ = ИСТИНА;
			ВОЗВРАТ ;	
		КонецЕсли;
	КонецЕсли;
	
	
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение и Склад.РаботаТолькоПоКомиссии = Истина Тогда
		Если НЕ Склад.Комитент.РаботаТолькоПоКомиссии = Истина Тогда
			   СоздатьДокументыДляВозвратаКомиссии();	
		КонецЕсли;
	КонецЕсли;
	
	Если ПометкаУдаления = Истина и Склад.РаботаТолькоПоКомиссии = Истина Тогда
		Если НЕ Склад.Комитент.РаботаТолькоПоКомиссии = Истина Тогда
			УдалитьДокументВозвратаКомиссии();	
		КонецЕсли;
	КонецЕсли;
	
	
    ЗаписатьДействияВИсториюДокумента(Изменения,РежимЗаписи,ПометкаУдаления);
	
КонецПроцедуры






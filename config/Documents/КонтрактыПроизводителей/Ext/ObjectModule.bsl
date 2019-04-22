﻿
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
	// ==>ENT-1275.Коробка.06.02.2019.Проверка заполнения поставщика у производителя 
	Иначе
		
		Если НЕ ЗначениеЗаполнено(Производитель.Поставщик) Тогда
			#Если Клиент Тогда
				Предупреждение("Производитель не привязан к поставщику. Документ не может быть проведен",3);
			#КонецЕсли
			Отказ = Истина;
		КонецЕсли; 
	// <==ENT-1275.Коробка.06.02.2019.Проверка заполнения поставщика у производителя 
		
	КонецЕсли;		
	
	Если НЕ Согласован Тогда
		#Если Клиент Тогда
			Предупреждение("Документ не прошел согласование. Проведение невозможно",3);
		#КонецЕсли
		Отказ = Истина;				
	КонецЕсли;
	
	Если Производитель.КодПоставщикаОриолы = 0 Тогда
		#Если Клиент Тогда
			Предупреждение("Не заполнено поле ""Код поставщика в ПО Ориола"" по производителю """ 
			+ Производитель + """. Проведение невозможно", 3);			
		#КонецЕсли
		Отказ = Истина;		
	КонецЕсли;

	Если ТипЦены.Пустая() Тогда
		#Если Клиент Тогда
			Предупреждение("Не указан тип цены. Проведение невозможно", 3);			
		#КонецЕсли
		Отказ = Истина;			
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Поставщик) Тогда
	
		Если ЗначениеЗаполнено(ДоговорПоставщика) Тогда
		
			Если ДоговорПоставщика.Владелец <> Производитель.Поставщик Тогда
			
				#Если Клиент Тогда
					Предупреждение("Договор поставщика не принадлежит поставщику, указанному в карточке производитетеля!",5);
				#КонецЕсли
				Отказ = Истина
			
			КонецЕсли; 
			
		Иначе
		
			#Если Клиент Тогда
				Предупреждение("Не указан договор поставщика!",5);
			#КонецЕсли	
			Отказ = Истина
		
		КонецЕсли;
		
	Иначе
		
		#Если Клиент Тогда
			Предупреждение("Не указан поставщик!",3);
		#КонецЕсли	
		Отказ = Истина
	
	КонецЕсли; 
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 		
		Если НЕ (РольДоступна("супер_АДМИНИСТРАТОР") или  РольДоступна("ОптовикиПолныеПрава")) Тогда		
			Предупреждение("Нет прав на проведение документа", 3);			
		КонецЕсли; 		
		
		ПроверитьНаЗаполнение(Отказ);	
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Для каждого стр из Товар Цикл
		РассчитатьЦеныСУчетомБонусов(стр);	
	КонецЦикла;
	
	Если ЭтоНовый() Тогда
		Изменение = Изменения.Добавить();
		Изменение.Дата = ТекущаяДата();
		Изменение.КомментарийИзменения = "Создан новый документ";
		Изменение.Сотрудник = ПараметрыСеанса.ТекущийСотр;
		Изменение.ТипИзм = Перечисления.ДействияНадДокументами.ВводНового;
		
		ИзменитьДатыДействияПредыдущихКонтрактов();
		
	КонецЕсли;
	
	ЗаписатьДействияВИсториюДокумента(Изменения,РежимЗаписи,ПометкаУдаления);	
	
КонецПроцедуры

Процедура ИзменитьДатыДействияПредыдущихКонтрактов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтрактыПроизводителей.Ссылка
	|ИЗ
	|	Документ.КонтрактыПроизводителей КАК КонтрактыПроизводителей
	|ГДЕ
	|	КонтрактыПроизводителей.Проведен
	|	И КонтрактыПроизводителей.Производитель = &Производитель
	|	И &Дата МЕЖДУ КонтрактыПроизводителей.НачалоПериода И КонтрактыПроизводителей.КонецПериода";
	
	Запрос.УстановитьПараметр("Дата", НачалоПериода);
	Запрос.УстановитьПараметр("Производитель", Производитель);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.КонецПериода = НачалоПериода - 24*60*60;
		
		Попытка
			Объект.Записать(РежимЗаписиДокумента.Запись);
			Сообщить("Изменена дата окончания действия предыдущего контракта (" + Объект.Ссылка + ")");
		Исключение
			Сообщить("Не удалось изменить дату окончания действия предыдущего контракта (" 
			+ Объект.Ссылка + "). Описание ошибки: " + ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Согласован = Ложь;
	СогласованКем = Справочники.Сотрудники.ПустаяСсылка();
	
КонецПроцедуры

Процедура РассчитатьЦеныСУчетомБонусов(ТекущаяСтрока) Экспорт
	 
	//КредитНота = Окр(ТекущаяСтрока.ЦенаЗакупБезНДС * (ТекущаяСтрока.БонусОптовый+ТекущаяСтрока.БонусСО)/100, 2);
	//sd61960
	//КредитНота = Окр(ТекущаяСтрока.ЦенаЗакупБезНДС * (ТекущаяСтрока.БонусОптовый)/100, 2);
	//ENT-561
	КредитНота = Окр(ТекущаяСтрока.ЦенаЗакупБезНДС * (ТекущаяСтрока.БонусОптовый+ТекущаяСтрока.БонусСО)/100, 2);
	Если ТипЦены = Перечисления.ТипыЦенКонтракта.СипЦена Тогда
	
		ЦенаСУчетомФинСкидкиБезНДС = Окр(ТекущаяСтрока.ЦенаЗакупБезНДС * (100-ТекущаяСтрока.БонусДополнительный)/100 + ТекущаяСтрока.ЦенаЗакупБезНДС * ТекущаяСтрока.БонусТП/100, 2);
		СуммаНДС = Окр(ЦенаСУчетомФинСкидкиБезНДС * ТекущаяСтрока.СтавкаНДС/100, 2);
	    ЦенаСУчетомФинСкидкиСНДС = ТекущаяСтрока.ЦенаЗакупБезНДС;
	    ЦенаИтогСНДС = Макс(ЦенаСУчетомФинСкидкиБезНДС + СуммаНДС - КредитНота,0);

	Иначе
	
		ЦенаСУчетомФинСкидкиБезНДС = Окр(ТекущаяСтрока.ЦенаЗакупБезНДС * (100-ТекущаяСтрока.БонусДополнительный)/100, 2);
		СуммаНДС = Окр(ЦенаСУчетомФинСкидкиБезНДС * ТекущаяСтрока.СтавкаНДС/100, 2);
		ЦенаСУчетомФинСкидкиСНДС = ЦенаСУчетомФинСкидкиБезНДС + СуммаНДС;
	    ЦенаИтогСНДС = Макс(ЦенаСУчетомФинСкидкиСНДС - КредитНота,0);
		
	КонецЕсли;
	
	ТекущаяСтрока.ЦенаСУчетомФинСкидкиСНДС = ЦенаСУчетомФинСкидкиСНДС;
	ТекущаяСтрока.ЦенаИтогСНДС = ЦенаИтогСНДС;
	ТекущаяСтрока.БонусЦОЗакупка =  ТекущаяСтрока.БонусОптовый + (1-ТекущаяСтрока.БонусОптовый / 100) * ТекущаяСтрока.БонусСО; //ENT-460
	
КонецПроцедуры

Процедура РассчитатьЦеныСУчетомБонусовСтарый(ТекущаяСтрока) Экспорт
	 
	ЦенаСУчетомФинСкидкиБезНДС = Окр(ТекущаяСтрока.ЦенаЗакупБезНДС * (100-ТекущаяСтрока.БонусДополнительный)/100, 2);
	КредитНота = Окр(ЦенаСУчетомФинСкидкиБезНДС * ТекущаяСтрока.БонусОптовый/100, 2); 
	СуммаНДС = Окр(ЦенаСУчетомФинСкидкиБезНДС * ТекущаяСтрока.СтавкаНДС/100, 2);	
	ЦенаСУчетомФинСкидкиСНДС = ЦенаСУчетомФинСкидкиБезНДС + СуммаНДС;
	ЦенаИтогСНДС = Макс(ЦенаСУчетомФинСкидкиСНДС - КредитНота, 0);
	
	ТекущаяСтрока.ЦенаСУчетомФинСкидкиСНДС = ЦенаСУчетомФинСкидкиСНДС;
	ТекущаяСтрока.ЦенаИтогСНДС = ЦенаИтогСНДС;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ЦеныПроизводителей
	Движения.ЦеныПроизводителей.Записывать = Истина;
	Движения.ЦеныПроизводителей.Очистить();
	Для Каждого ТекСтрокаТовар Из Товар Цикл
		Движение = Движения.ЦеныПроизводителей.Добавить();
		Движение.Период						= НачалоДня(Дата);
		Движение.КодТовара					= ТекСтрокаТовар.КодТовара;
		Движение.ЦенаЗакупБезНДС			= ТекСтрокаТовар.ЦенаЗакупБезНДС;
		Движение.БонусДополнительный		= ТекСтрокаТовар.БонусДополнительный;
		Движение.ЦенаСУчетомФинСкидкиСНДС	= ТекСтрокаТовар.ЦенаСУчетомФинСкидкиСНДС;
		Движение.Кратность					= ТекСтрокаТовар.Кратность;
		Движение.БонусТП					= ТекСтрокаТовар.БонусТП;
		Движение.ДатаДокумента				= Дата;
		Движение.Производитель				= Производитель;
		Движение.ТипЦены					= ТипЦены;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры



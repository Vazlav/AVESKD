﻿Процедура ОповеститьМенеджера()
	
	
	МПочтец = Обработки.Почтарь;
	Почтец = МПочтец.Создать();
	
	Почтец.Автоотправка = Истина;
	
	Почтец.Рассылка.Очистить();			
	Почтец.Рассылка.Добавить("vasilchenkoa.a.g@366.ru");
	
	Почтец.Тема = "Проведена заявка на отгрузку : " + Ссылка;
	Почтец.ТекстПисьма = "Проведена заявка на отгрузку : " + Ссылка  +  "
	|Сумма заказа: " + СуммаОтпускнаяОптБезНДС  + "
	|Количество позиций: " + Товар.Количество() + " 
	|";
	
	Почтец.Функция_Послать();
	
	Почтец = Неопределено;
	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ЗаказПроизводителю Приход
	Движения.ЗаявкаНаОптовуюОтгрузку.Очистить();
	
	КодКлиента = Клиент.Код;
	Движения.ЗаявкаНаОптовуюОтгрузку.Записывать = Истина;
	Для Каждого ТекСтрокаТовар Из Товар Цикл
		Если ТекСтрокаТовар.ПотребностьВКоробах  = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Движение = Движения.ЗаявкаНаОптовуюОтгрузку.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.КодКлиента = КодКлиента;
		Движение.КодТовара = ТекСтрокаТовар.КодТовара;
		Движение.Заявка = Ссылка;
		Движение.Количество = ТекСтрокаТовар.ПотребностьВКоробах;
		Движение.СуммаЗакупБезНДС = ТекСтрокаТовар.СуммаЗакупБезНДС;
	КонецЦикла;
	
	
	//ОповеститьМенеджера();

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры

Процедура ПроверитьНаЗаполнениеПриПроведении(Отказ)
	
	    
	Если ИгнорироватьПроверкиЦО Тогда
		Если Проведен = Ложь И НЕ Статус = Перечисления.СтатусыЗаявкиНаОтгрузку.СогласованФИН Тогда
			#Если Клиент Тогда
				Предупреждение("Документ не прошел согласование ФИН. Проведение невозможно",3);
			#КонецЕсли
			Отказ = Истина;	
		КонецЕсли;
	КонецЕсли;
	
	Если Производитель.Пустая() Тогда
		#Если Клиент Тогда
			Предупреждение("В документе не выбран производитель. Документ не может быть проведен",3);
		#КонецЕсли
		Отказ = Истина;	
	КонецЕсли;
		
КонецПроцедуры
	
Процедура ПроверитьНаЗаполнениеПриЗаписи(Отказ)	
	
	Т = "";
	Для каждого стр из Товар Цикл
		Если стр.ЦенаОтпускнаяОптБезНДС < стр.МинЦенаОптБезНДС Тогда
			Т = Т + "по товару : "  + стр.Товар + " ЦенаОтпускнаяОптБезНДС < МинЦенаОптБезНДС " + Символы.ПС;
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ Т = "" Тогда
		Сообщить(Т);
	КонецЕсли;
	
		
КонецПроцедуры

Процедура УстановитьСтатусДокумента(РежимЗаписи)
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Статус) Тогда
		Статус = Перечисления.СтатусыЗаявкиНаОтгрузку.Создан;	
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда	
		Статус = Перечисления.СтатусыЗаявкиНаОтгрузку.Проведен;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	
	ДатаПоследнегоИзменения = ТекущаяДата();
	
	СуммаЗакупБезНДС = Товар.Итог("СуммаЗакупБезНДС");
	СуммаОтпускнаяОптБезНДС = Товар.Итог("СуммаОтпускнаяОптБезНДС");
	СуммаОтпускнаяОптСНДС = Товар.Итог("СуммаОтпускнаяОптСНДС");
	
	Если НЕ ИгнорироватьПроверкиЦО Тогда
		ПроверитьНаЗаполнениеПриЗаписи(Отказ);
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьНаЗаполнениеПриПроведении(Отказ);	
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьСтатусДокумента(РежимЗаписи);
	
	
	Если ЭтоНовый() Тогда
		Изменение = Изменения.Добавить();
		Изменение.Дата = ТекущаяДата();
		Изменение.КомментарийИзменения = "Создан новый документ";
		Изменение.Сотрудник = ПараметрыСеанса.ТекущийСотр;
		Изменение.ТипИзм = Перечисления.ДействияНадДокументами.ВводНового;
		
		СозданКем = ПараметрыСеанса.ТекущийСотр;
		
	КонецЕсли;
	
	ЗаписатьДействияВИсториюДокумента(Изменения,РежимЗаписи,ПометкаУдаления,Истина);	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// Оповещения менеджеров о смене статуса
	
	Если Статус = Перечисления.СтатусыЗаявкиНаОтгрузку.Создан И ИгнорироватьПроверкиЦО = Истина Тогда
		ОМ_ТСО.ЗарегистрироватьОбъектДляВыгрузки(Ссылка, Перечисления.ВидыВыгрузок.ЗаявкаНаОптовуюОтгрузку_ОповещениеОСтатусеСоздан);
	ИначеЕсли Статус = Перечисления.СтатусыЗаявкиНаОтгрузку.СогласованЦО Тогда
		ОМ_ТСО.ЗарегистрироватьОбъектДляВыгрузки(Ссылка, Перечисления.ВидыВыгрузок.ЗаявкаНаОптовуюОтгрузку_ОповещениеОСтатусеСогласованЦО);
	ИначеЕсли Статус = Перечисления.СтатусыЗаявкиНаОтгрузку.СогласованФИН Тогда
		ОМ_ТСО.ЗарегистрироватьОбъектДляВыгрузки(Ссылка, Перечисления.ВидыВыгрузок.ЗаявкаНаОптовуюОтгрузку_ОповещениеОСтатусеСогласованФИН);
	ИначеЕсли Статус = Перечисления.СтатусыЗаявкиНаОтгрузку.Проведен Тогда
		ОМ_ТСО.ЗарегистрироватьОбъектДляВыгрузки(Ссылка, Перечисления.ВидыВыгрузок.ЗаявкаНаОптовуюОтгрузку_ОповещениеОСтатусеПроведен);
	КонецЕсли;	
	
КонецПроцедуры


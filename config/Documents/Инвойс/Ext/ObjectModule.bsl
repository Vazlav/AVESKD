﻿Процедура ПоместитьВОбменСкладБух() экспорт  // GTG 02-04-2016
	
	Запрос=Новый Запрос();
	Запрос.Текст="ВЫБРАТЬ
	             |	400 КАК ВидДокумента,
	             |	Инвойс.Фирма.Код КАК КодФирмы,
	             |	""123456789012345678901234567890123456"" КАК СсылкаТХТ,
	             |	Инвойс.Дата КАК ДатаОчередиСклад,
	             |	0 КАК КодСклада,
	             |	0 КАК КодКонтрагента,
	             |	Инвойс.Ссылка КАК Объект,
	             |	Инвойс.Проведен КАК Проведен,
	             |	Инвойс.ПометкаУдаления КАК ПомеченНаУдаление,
	             |	"""" КАК ОшибкаПриЗагрузке
	             |ИЗ
	             |	Документ.Инвойс КАК Инвойс
	             |ГДЕ
	             |	Инвойс.Ссылка = &Ссылка";
	
	
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	Рез=Запрос.Выполнить();
	
	Если Рез.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выб=Рез.Выбрать();
	Выб.Следующий();
	
	
	МЗ=РегистрыСведений.ОбменСкладБух.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МЗ,Выб);
	
	Мз.СсылкаТХТ=МЗ.Объект.УникальныйИдентификатор();
	МЗ.Записать();
	
		
	
КонецПроцедуры

Процедура ПровестиПоНовымРегистрам(КодПроизводителя,Отказ)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "ВЫБРАТЬ
	|	Расход.КодТовара КАК КодТовара,
	|	Расход.Товар КАК Товар,
	|	Расход.ПодтверждениеЗаказа,
	|	СУММА(Расход.Количество*Расход.ЦенаУчета) КАК СуммаЗаказа,
	|	СУММА(Расход.Количество) КАК Количество
	|ПОМЕСТИТЬ ДокТЧ
	|ИЗ
	|	Документ.Инвойс.Товар КАК Расход
	|ГДЕ
	|	Расход.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Расход.ПодтверждениеЗаказа,
	|	Расход.КодТовара,
	|	Расход.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокТЧ.КодТовара КАК КодТовара,
	|	ДокТЧ.Товар КАК Товар,
	|	ДокТЧ.Количество КАК Количество,
	|	ДокТЧ.СуммаЗаказа КАК СуммаЗаказа,
	|	ДокТЧ.ПодтверждениеЗаказа
	|ИЗ
	|	ДокТЧ КАК ДокТЧ";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	Движения.ПодтверждениеЗаказа.Записывать = Истина;
	Выборка = РезультатЗапроса.Выбрать();

	
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ПодтверждениеЗаказа.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.КодПроизводителя = КодПроизводителя;
		Движение.КодТовара = Выборка.КодТовара;
		Движение.Заказ = ДокументОснование;
		Движение.ПодтверждениеЗаказа = Выборка.ПодтверждениеЗаказа;
		Движение.Количество = Выборка.Количество;
		Движение.СуммаЗаказа = Выборка.СуммаЗаказа;
	КонецЦикла; 
	Движения.Записать();
	
	
	Запрос.Текст = "ВЫБРАТЬ
	|	Подтверждение.КодТовара КАК КодТовара,
	|	Подтверждение.ПодтверждениеЗаказа как ПодтверждениеЗаказа,
	|	Подтверждение.КоличествоОстаток КАК Остаток
	|ИЗ
	|	РегистрНакопления.ПодтверждениеЗаказа.Остатки(
	|			,
	|			КодТовара В
	|					(ВЫБРАТЬ
	|						ДокТЧ.КодТовара
	|					ИЗ
	|						ДокТЧ КАК ДокТЧ)
	|				И Заказ = &Заказ) КАК Подтверждение
	|ГДЕ
	|	Подтверждение.КоличествоОстаток < 0";
	
	Запрос.УстановитьПараметр("Заказ", ДокументОснование);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаОст = РезультатЗапроса.Выбрать();
	Пока ВыборкаОст.Следующий() Цикл
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Превышение количества по коду  " + Формат(ВыборкаОст.КодТовара,"ЧГ=0") + " , после проведения документа остаток составит " + ВыборкаОст.Остаток;
		Сообщение.Сообщить();
		Отказ = Истина;        
	КонецЦикла; 
	
	Если Отказ = Истина Тогда
		Возврат;
	КонецЕсли;
	
	
	Движения.ОжидаемыйТовар.Записывать = Истина;
	Выборка.Сбросить();
	
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ОжидаемыйТовар.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.КодПроизводителя = КодПроизводителя;
		Движение.КодТовара = Выборка.КодТовара;
		Движение.Заказ = ДокументОснование;
		Движение.ПодтверждениеЗаказа = Выборка.ПодтверждениеЗаказа;
		Движение.Количество = Выборка.Количество;
		Движение.СуммаЗаказа = Выборка.СуммаЗаказа;
	КонецЦикла; 
	
	Если ДатаОприходования <> Дата(1,1,1) Тогда
		Выборка.Сбросить();
		Пока Выборка.Следующий() Цикл
			Движение = Движения.ОжидаемыйТовар.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = ДатаОприходования;
			Движение.КодПроизводителя = КодПроизводителя;
			Движение.КодТовара = Выборка.КодТовара;
			Движение.Заказ = ДокументОснование;
			Движение.ПодтверждениеЗаказа = Выборка.ПодтверждениеЗаказа;
			Движение.Количество = Выборка.Количество;
			Движение.СуммаЗаказа = Выборка.СуммаЗаказа;
		КонецЦикла;
	КонецЕсли;
	
	Движения.ОжидаемыйТовар.Записать();
	 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.ЗаказПроизводителю.Записывать = Истина;
	Движения.ЗаказПроизводителю.Очистить();
	Движения.ЗаказПоставщику.Записывать = Истина;
	Движения.ЗаказПоставщику.Очистить();	

	КодПроизводителя = Производитель.Код;

	
	Если ЗначениеЗаполнено(ДокументОснование)  И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаказПроизводителю") и Товар.Найти(Документы.ПодтверждениеЗаказа.ПустаяСсылка(),"ПодтверждениеЗаказа") = Неопределено Тогда
		ПровестиПоНовымРегистрам(КодПроизводителя, Отказ);
	Иначе
		// регистр ЗаказПроизводителю Приход
		Если ЗначениеЗаполнено(ДокументОснование) 
			И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаказПроизводителю") 
			И ДатаОприходования <> Дата(1,1,1) Тогда
			
			//Движения.ЗаказПроизводителю.Записывать = Истина;
			//Движения.ЗаказПроизводителю.Очистить();
			
			
			Для Каждого ТекСтрокаТовар Из Товар Цикл
				Движение = Движения.ЗаказПроизводителю.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = ДатаОприходования;
				Движение.КодПроизводителя = КодПроизводителя;
				Движение.КодТовара = ТекСтрокаТовар.КодТовара;
				Движение.Заказ = ДокументОснование;
				Движение.Количество = ТекСтрокаТовар.Количество;
				Движение.Цена = ТекСтрокаТовар.ЦенаОтпускнаяБезНДС;
				
			КонецЦикла;
			
			
			
			
			
		ИначеЕсли ЗначениеЗаполнено(ДокументОснование) 
			И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.Заказ") 
			И ДатаОприходования <> Дата(1,1,1) Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	&Ссылка КАК Регистратор,
			               |	ТЗДляЗаказа.Товар КАК Товар,
			               |	СУММА(ТЗДляЗаказа.Количество) КАК Количество,
			               |	МАКСИМУМ(ТЗДляЗаказа.ЦенаОтпускнаяСНДС) КАК ЦенаЗакуп,
			               |	&Дата КАК Период,
			               |	&ПоставщикВЗаказе КАК Поставщик,
			               |	&Склад КАК Склад,
			               |	&ДатаЗаказа КАК ДатаЗаказа,
			               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения
			               |ИЗ
			               |	Документ.Инвойс.Товар КАК ТЗДляЗаказа
			               |ГДЕ
			               |	ТЗДляЗаказа.Ссылка = &Ссылка
			               |
			               |СГРУППИРОВАТЬ ПО
			               |	ТЗДляЗаказа.Товар";
			Запрос.УстановитьПараметр("Дата",КонецДня(ДатаОприходования)+1);  //WO 44062  Инвойсы интернет-аптеки, с датой приемки "сегодня" должны учитываться как товар в пути
			Запрос.УстановитьПараметр("Склад",ДокументОснование.Склад);
			Запрос.УстановитьПараметр("ПоставщикВЗаказе",ДокументОснование.Поставщик);
			Запрос.УстановитьПараметр("ДатаЗаказа",ДокументОснование.Дата);

			Запрос.УстановитьПараметр("Ссылка",Ссылка);
			ТЗДляЗакрытия = Запрос.Выполнить().Выгрузить();
			//Движения.ЗаказПоставщику.Записывать = Истина;
			//Движения.ЗаказПоставщику.Очистить();
			Движения.ЗаказПоставщику.Загрузить(ТЗДляЗакрытия);
			
		КонецЕсли;
	КонецЕсли;
	
	Если ОтветственноеХранение и ЗначениеЗаполнено(КонтрагентОтветственногоХранения) Тогда
		ПоместитьВОбменСкладБух();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьНаЗаполнение(Отказ)
	
	Если ДатаОплаты = Дата(1,1,1) Тогда
		#Если Клиент Тогда
			Предупреждение("Не указана дата оплаты. Документ не может быть проведен",3);
		#КонецЕсли
		Отказ = Истина;	
	КонецЕсли;
	
	Если Производитель.Пустая() Тогда
		#Если Клиент Тогда
			Предупреждение("В документе не выбран производитель. Документ не может быть проведен",3);
		#КонецЕсли
		Отказ = Истина;	
	КонецЕсли;	
	
	Если (НачалоДня(Дата) > НачалоДня(ДатаОприходования)) и (НЕ ДатаОприходования = Дата(1,1,1)) Тогда
		#Если Клиент Тогда
			Предупреждение("Дата оприходования меньше даты документа. Документ не может быть проведен",3);
		#КонецЕсли
		Отказ = Истина;			
	КонецЕсли;
	
	Если СтатусВыгрузки <> Перечисления.СтатусыВыгрузки.Выгружен И ЕстьТоварыБезПерекодировки() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если НесопоставленныйТовар.Количество() > 0 Тогда
		#Если Клиент Тогда
			Предупреждение("Присутствует несопоставленный товар. Документ не может быть проведен",3);
		#КонецЕсли
		Отказ = Истина;		
	КонецЕсли;
	
	Если ТипЗнч(Производитель) = Тип("СправочникСсылка.Производители") Тогда		
		Если Производитель.КодПоставщикаОриолы = 0 Тогда		
			#Если Клиент Тогда
				Сообщить("Отсутствует перекодировка с поставщиком ""ДЖИ ДИ ПИ"" по производителю: " + Производитель);			
			#КонецЕсли
			Отказ = Истина;		
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

Функция ЕстьТоварыБезПерекодировки()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АП.Наименование КАК Товар
	|ИЗ
	|	Справочник.АССОРТИМЕНТНЫЙ_ПЛАН КАК АП
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СвязкиТовараСПоставщиком КАК Связки
	|		ПО АП.Ссылка = Связки.ТоварФирмы
	|			И (Связки.Поставщик = &ПоставщикСвязок)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СвязкиТовараСПоставщиком КАК СвязкиПоОП
	|		ПО АП.КодОП = СвязкиПоОП.ТоварФирмы.Код
	|			И (СвязкиПоОП.Поставщик = &ПоставщикСвязок)
	|ГДЕ
	|	Связки.КодТовараПоставщика ЕСТЬ NULL
	|	И СвязкиПоОП.КодТовараПоставщика ЕСТЬ NULL
	|	И АП.Ссылка В(&Товары)";

	Запрос.УстановитьПараметр("ПоставщикСвязок", Справочники.Поставщики.НайтиПоКоду(582));
	Запрос.УстановитьПараметр("Товары", Товар.ВыгрузитьКолонку("Товар"));

	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда		
		Выборка = РезультатЗапроса.Выбрать();		
		Пока Выборка.Следующий() Цикл
			#Если Клиент Тогда
				Сообщить("Отсутствует перекодировка с поставщиком ""ДЖИ ДИ ПИ"" по товару: " + Выборка.Товар);			
			#КонецЕсли
		КонецЦикла;
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Сумма = Товар.Итог("СуммаОтпускнаяСНДС");
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Если Не ПроверитьЗаполнение() Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ПроверитьНаЗаполнение(Отказ);	
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтатусВыгрузки) Тогда
			СтатусВыгрузки = Перечисления.СтатусыВыгрузки.ОжидаетВыгрузки;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаписатьДействияВИсториюДокумента(Изменения,РежимЗаписи,ПометкаУдаления);
	
	Если ЭтоНовый() И Изменения.Количество() = 0 Тогда
		Изменение = Изменения.Добавить();
		Изменение.Дата = ТекущаяДата();
		Изменение.КомментарийИзменения = "Создан новый документ";
		Изменение.Сотрудник = ПараметрыСеанса.ТекущийСотр;
		Изменение.ТипИзм = Перечисления.ДействияНадДокументами.ВводНового;
	КонецЕсли;
	
КонецПроцедуры
 	
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если
		Метаданные.НайтиПоТипу(ТипЗнч(ДанныеЗаполнения)) = Метаданные.Документы.РеализацияОптом
		ИЛИ
		Метаданные.НайтиПоТипу(ТипЗнч(ДанныеЗаполнения)) = Метаданные.Документы.УЗ_МелкооптоваяРеализация
	Тогда
		СтандартнаяОбработка = Ложь;
		ADHOC.СформироватьИнвойсНаОснованииРеализацииОптом( ДанныеЗаполнения.Ссылка, , , ЭтотОбъект, Ложь);
		//Начало НЭТИ Барданов А.Ю. 29.12.2018 ENT-855 оптимизация создания инвойса в 1С Склад
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПодтверждениеЗаказа") Тогда
		Производитель = ДанныеЗаполнения.Производитель;
		ДокументОснование = ДанныеЗаполнения.ДокументОснование; 
		ПодтверждениеЗаказа = ДанныеЗаполнения.Ссылка;
		ДатаПоставки = ДанныеЗаполнения.ДатаПоставки;
		ИдентификаторEDI = ДанныеЗаполнения.ИдентификаторEDI;
		Комментарий = ДанныеЗаполнения.Комментарий;
		Дата = ТекущаяДата();
		ТипПоставки = Справочники.ТипыПоставокНаСклад.НайтиПоКоду(4);  		
		РассчитатьДатуОплатыОбъект();
		Для Каждого ТекСтрокаНесопоставленныйТовар Из ДанныеЗаполнения.НесопоставленныйТовар Цикл
			НоваяСтрока = НесопоставленныйТовар.Добавить();
			НоваяСтрока.Баркод = ТекСтрокаНесопоставленныйТовар.Баркод;
			НоваяСтрока.КодТовараПоставщика = ТекСтрокаНесопоставленныйТовар.КодТовараПоставщика;
			НоваяСтрока.Количество = ТекСтрокаНесопоставленныйТовар.Количество;
			НоваяСтрока.НаименованиеТовараПоставщика = ТекСтрокаНесопоставленныйТовар.НаименованиеТовараПоставщика;
			НоваяСтрока.СрокГодности = ТекСтрокаНесопоставленныйТовар.СрокГодности;
		КонецЦикла;
		Для Каждого ТекСтрокаТовар Из ДанныеЗаполнения.Товар Цикл
			НоваяСтрока = Товар.Добавить();
			НоваяСтрока.КодТовара = ТекСтрокаТовар.КодТовара;
			НоваяСтрока.Товар = ТекСтрокаТовар.Товар;
			//Начало НЭТИ Барданов А.Ю. 25.01.2019 ENT-1178 оптимизация создания инвойса в 1С Склад
			Если ТекСтрокаТовар.СтавкаНДСПроизводителя = 20 И ДанныеЗаполнения.Дата < Дата(2019, 1, 1) Тогда
				НоваяСтрока.СтавкаНДС = Справочники.СтавкиНДС.НайтиПоРеквизиту("Ставка",18);
			Иначе
				НоваяСтрока.СтавкаНДС = Справочники.СтавкиНДС.НайтиПоРеквизиту("Ставка",ТекСтрокаТовар.СтавкаНДСПроизводителя);
			КонецЕсли;
			НоваяСтрока.Количество = ТекСтрокаТовар.Количество;
			НоваяСтрока.ЦенаЗаказа = ТекСтрокаТовар.ЦенаЗаказа;
			НоваяСтрока.ЦенаОтпускнаяСНДС = ТекСтрокаТовар.ЦенаСоСкидкойСНДС;
			НоваяСтрока.СуммаОтпускнаяСНДС = НоваяСтрока.Количество*НоваяСтрока.ЦенаОтпускнаяСНДС;
			НоваяСтрока.ЦенаОтпускнаяБезНДС = НоваяСтрока.ЦенаОтпускнаяСНДС / (1+ПереопределениеЗначенияСтавки20_18(НоваяСтрока.СтавкаНДС,ДанныеЗаполнения.Дата)/100); 
			НоваяСтрока.СуммаНДС = НоваяСтрока.СуммаОтпускнаяСНДС - НоваяСтрока.ЦенаОтпускнаяБезНДС * НоваяСтрока.Количество;
			НоваяСтрока.СрокГодности = ТекСтрокаТовар.СрокГодности;   			
			НоваяСтрока.ПодтверждениеЗаказа = ДанныеЗаполнения.Ссылка;
			НоваяСтрока.ЦенаУчета = ТекСтрокаТовар.ЦенаУчета;
			//Конец НЭТИ Барданов А.Ю. 25.01.2019 ENT-1178 оптимизация создания инвойса в 1С Склад
		КонецЦикла;
	//Конец НЭТИ Барданов А.Ю. 29.12.2018 ENT-855
	КонецЕсли; 	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если СтатусВыгрузки <> Перечисления.СтатусыВыгрузки.Аннулирован Тогда
		Сообщить("Отмена проведения инвойса возможна только по кнопке ""Аннулировать""");
		Отказ = Истина;
		Возврат;		
	КонецЕсли;	
	
КонецПроцедуры

//НЭТИ Барданов А.Ю. 06.02.2019 ENT-1265
Функция ПолучитьКоличествоДнейОтсрочкиОбъект() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КонтрактыПроизводителей.ДнейОтсрочки
	|ИЗ
	|	Документ.КонтрактыПроизводителей КАК КонтрактыПроизводителей
	|ГДЕ
	|	КонтрактыПроизводителей.Производитель = &Производитель
	|	И &Дата МЕЖДУ КонтрактыПроизводителей.НачалоПериода И КонтрактыПроизводителей.КонецПериода
	|
	|УПОРЯДОЧИТЬ ПО
	|	КонтрактыПроизводителей.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Производитель", Производитель);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 0;
		
	Иначе
		Выборка = РезультатЗапроса.Выбрать();		
		Выборка.Следующий();
		
		Возврат Выборка.ДнейОтсрочки;
		
	КонецЕсли;
	
КонецФункции

//НЭТИ Барданов А.Ю. 06.02.2019 ENT-1265
Процедура РассчитатьДатуОплатыОбъект() Экспорт
	
	ДнейОтсрочки = ПолучитьКоличествоДнейОтсрочкиОбъект();
	Если ДнейОтсрочки > 0 Тогда
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаказПроизводителю") 
			И ЗначениеЗаполнено(ДокументОснование.ДатаПоставки) Тогда
			ДатаПоставки = ДокументОснование.ДатаПоставки;
		Иначе
			ДатаПоставки = Дата;
		КонецЕсли;
		
		ДатаОплаты = ДатаПоставки + ДнейОтсрочки*24*60*60;
		
	Иначе
		ДатаОплаты = Дата(1,1,1);
		
	КонецЕсли;
	
КонецПроцедуры

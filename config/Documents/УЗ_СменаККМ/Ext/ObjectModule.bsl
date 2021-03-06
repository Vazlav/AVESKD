﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос=Новый Запрос();

	Если Дата >= Дата(2017,08,18) Тогда
		Запрос.Текст = "ВЫБРАТЬ
		|	&Регистратор КАК Регистратор,
		|	&Период КАК Период,
		|	ИСТИНА КАК активность,
		|	&ВидДвижения КАК ВидДвижения,
		|	&Склад КАК Склад,
		|	СУММА(УЗ_СменаККМПродажиТовара.СуммаРозн) КАК Сумма
		|ИЗ
		|	Документ.УЗ_СменаККМ.ПродажиТовара КАК УЗ_СменаККМПродажиТовара
		|ГДЕ
		|	УЗ_СменаККМПродажиТовара.Ссылка = &Регистратор
		|	И УЗ_СменаККМПродажиТовара.ТипОплаты = 0";
		
		Запрос.УстановитьПараметр("Регистратор",ЭтотОбъект.Ссылка);
		Запрос.УстановитьПараметр("Склад",Справочники.МестаХранения.НайтиПоКоду(СкладКод));
		Запрос.УстановитьПараметр("Период",Дата);
		Запрос.УстановитьПараметр("ВидДвижения",ВидДвиженияНакопления.Приход);	
		
		
		
		НЗ=РегистрыНакопления.ОперационнаяКасса.СоздатьНаборЗаписей();
		НЗ.Отбор.Регистратор.Установить(ЭтотОбъект.Ссылка);
		НЗ.Загрузить(Запрос.Выполнить().Выгрузить());
		НЗ.Записать();
	КонецЕсли;
	
	
	//---------------<УЗ_ПродажиСменККМ>---------------------------// GtG // 31.12.2015 18:20:32
	
	
	Запрос.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |	&Регистратор КАК Регистратор,
	             |	&Период КАК Период,
	             |	ИСТИНА КАК активность,
	             |	&ВидДвижения КАК ВидДвижения,
	             |	&ФирмаКод КАК ФирмаКод,
	             |	&СкладКод КАК СкладКод,
	             |	УЗ_СменаККМПродажиТовара.КодТовара КАК ТоварКод,
	             |	УЗ_СменаККМПродажиТовара.КодПартии КАК ПартияКод,
	             |	УЗ_СменаККМПродажиТовара.ВидПоступленияПорядок КАК ВидПоступленияПорядок,
	             |	УЗ_СменаККМПродажиТовара.СтавкаНДСЗакуп КАК СтавкаНДСЗакуп,
	             |	УЗ_СменаККМПродажиТовара.Количество КАК Количество,
	             |	УЗ_СменаККМПродажиТовара.СуммаЗакупБезНДС КАК СуммаЗакупБезНДС,
	             |	УЗ_СменаККМПродажиТовара.GuidЧека КАК GuidЧека,
	             |	УЗ_СменаККМПродажиТовара.СуммаРозн КАК СуммаРозн
	             |ИЗ
	             |	Документ.УЗ_СменаККМ.ПродажиТовара КАК УЗ_СменаККМПродажиТовара
	             |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |			УЗ_ПродажиСменККМ.GuidЧека КАК GuidЧека,
	             |			УЗ_ПродажиСменККМ.Регистратор КАК Регистратор
	             |		ИЗ
	             |			РегистрНакопления.УЗ_ПродажиСменККМ КАК УЗ_ПродажиСменККМ
	             |		ГДЕ
	             |			УЗ_ПродажиСменККМ.Регистратор = &Регистратор) КАК ВложенныйЗапрос
	             |		ПО УЗ_СменаККМПродажиТовара.GuidЧека = ВложенныйЗапрос.GuidЧека
	             |ГДЕ
	             |	ВложенныйЗапрос.GuidЧека ЕСТЬ NULL
	             |	И УЗ_СменаККМПродажиТовара.Ссылка = &Регистратор
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	GuidЧека,
	             |	ТоварКод,
	             |	ПартияКод";
	
	Запрос.УстановитьПараметр("Регистратор",ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("СкладКод",СкладКод);
	Запрос.УстановитьПараметр("ФирмаКод",ФирмаКод);
	Запрос.УстановитьПараметр("Период",Дата);
	Запрос.УстановитьПараметр("ВидДвижения",ВидДвиженияНакопления.Расход);
	
	НЗ=РегистрыНакопления.УЗ_ПродажиСменККМ.СоздатьНаборЗаписей();
	НЗ.Отбор.Регистратор.Установить(ЭтотОбъект.Ссылка);
	НЗ.Загрузить(Запрос.Выполнить().Выгрузить());
	НЗ.Записать(Ложь);
	
	
	//---------------<ОТЧ_ОтчетПоВыручке>---------------------------// GtG // 31.12.2015 18:20:48     
	Запрос.Текст="ВЫБРАТЬ
	             |	&Регистратор,
	             |	&Период,
	             |	ИСТИНА КАК Активность,
	             |	&ФирмаКод,
	             |	&СкладКод,
	             |	СУММА(база.КоличествоЧеков) КАК КолвоЧеков,
	             |	СУММА(база.КоличествоНаименованийВЧеке) КАК КоличествоНаименованийВЧеке,
	             |	СУММА(база.СуммаРозн) КАК СуммаВыручки,
	             |	&КомментарийДляОПВ
	             |ИЗ
	             |	(ВЫБРАТЬ
	             |		СУММА(УЗ_СменаККММотивация_Итоги.КоличествоЧеков) КАК КоличествоЧеков,
	             |		СУММА(УЗ_СменаККММотивация_Итоги.КоличествоНаименованийВЧеке) КАК КоличествоНаименованийВЧеке,
	             |		0 КАК СуммаРозн
	             |	ИЗ
	             |		Документ.УЗ_СменаККМ.Мотивация_Итоги КАК УЗ_СменаККММотивация_Итоги
	             |	ГДЕ
	             |		УЗ_СменаККММотивация_Итоги.Ссылка = &Регистратор
	             |	
	             |	ОБЪЕДИНИТЬ ВСЕ
	             |	
	             |	ВЫБРАТЬ
	             |		0,
	             |		0,
	             |		СУММА(УЗ_СменаККМПродажиТовара.СуммаРозн)
	             |	ИЗ
	             |		Документ.УЗ_СменаККМ.ПродажиТовара КАК УЗ_СменаККМПродажиТовара
	             |	ГДЕ
	             |		УЗ_СменаККМПродажиТовара.Ссылка = &Регистратор
	             |	
	             |	ОБЪЕДИНИТЬ ВСЕ
	             |	
	             |	ВЫБРАТЬ
	             |		0,
	             |		0,
	             |		СУММА(УЗ_СменаККМАвансы_ПолучениеИВозврат.Сумма - УЗ_СменаККМАвансы_ПолучениеИВозврат.СуммаВозврат)
	             |	ИЗ
	             |		Документ.УЗ_СменаККМ.Авансы_ПолучениеИВозврат КАК УЗ_СменаККМАвансы_ПолучениеИВозврат
	             |	ГДЕ
	             |		УЗ_СменаККМАвансы_ПолучениеИВозврат.Ссылка = &Регистратор
	             |	
	             |	ОБЪЕДИНИТЬ ВСЕ
	             |	
	             |	ВЫБРАТЬ
	             |		0,
	             |		0,
	             |		СУММА(УЗ_СменаККМУслуги.СуммаРозн)
	             |	ИЗ
	             |		Документ.УЗ_СменаККМ.Услуги КАК УЗ_СменаККМУслуги
	             |	ГДЕ
	             |		УЗ_СменаККМУслуги.Ссылка = &Регистратор) КАК база";
				 
				 Если Корректная=Ложь Тогда
					 Запрос.УстановитьПараметр("КомментарийДляОПВ","Смена еще не закрыта.");
				 Иначе
					 Запрос.УстановитьПараметр("КомментарийДляОПВ","ОК.");
				 КонецЕсли;	 
				 
			НЗ=РегистрыНакопления.ОТЧ_ОтчетПоВыручке.СоздатьНаборЗаписей();
			НЗ.Отбор.Регистратор.Установить(ЭтотОбъект.Ссылка);
			НЗ.Загрузить(Запрос.Выполнить().Выгрузить());
			НЗ.Записать(Истина);
	
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	// Автоматическое удаление движений отключено
	
	Движения.УЗ_ПродажиСменККМ.Очистить();
	Движения.УЗ_ПродажиСменККМ.Записать();
	
	Движения.ОТЧ_ОтчетПоВыручке.Очистить();
	Движения.ОТЧ_ОтчетПоВыручке.Записать();
	
	Движения.ОперационнаяКасса.Очистить();
	Движения.ОперационнаяКасса.Записать();
	
	
КонецПроцедуры

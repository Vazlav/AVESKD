﻿
Функция ПолучитьВремяСервера() Экспорт
	
	Возврат ТекущаяДата();
	
КонецФункции

Процедура УстановкаРеквизитаСпецпроект(Товар, Спецпроект) Экспорт
	
	ТекОбъект = Товар.ПолучитьОбъект();
	ТекОбъект.Спецпроект = Спецпроект;
	ТекОбъект.Записать();
	
КонецПроцедуры

Процедура УстановитьСтатусВыгрузки(ДокСсылка, СтатусВыгрузки) Экспорт
	
	ДокОбъект = ДокСсылка.ПолучитьОбъект();
	Если ТипЗнч(СтатусВыгрузки) = Тип("ПеречислениеСсылка.СтатусыИсходящегоСообщенияEDI")
		Или ТипЗнч(СтатусВыгрузки) = Тип("ПеречислениеСсылка.СтатусыВходящегоСообщенияEDI") Тогда
		ДокОбъект.СтатусEDI = СтатусВыгрузки;
	Иначе
		ДокОбъект.СтатусВыгрузки = СтатусВыгрузки;
	КонецЕсли;
	ДокОбъект.Записать(РежимЗаписиДокумента.Запись);
	
КонецПроцедуры
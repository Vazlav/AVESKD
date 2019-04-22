﻿
Процедура ПередЗаписью(Отказ)
	
	Если ЭтоНовый()=Истина ТОгда
		Запрос=Новый Запрос("ВЫБРАТЬ
		                    |	ИА_РазбивочныйТовар.Товар,
		                    |	ИА_РазбивочныйТовар.ЕИТ_НаСайте,
		                    |	ИА_РазбивочныйТовар.ЕИТ_НаСайте.К как к
		                    |ИЗ
		                    |	Справочник.ИА_РазбивочныйТовар КАК ИА_РазбивочныйТовар
		                    |ГДЕ
		                    |	ИА_РазбивочныйТовар.Товар = &Товар");
		Запрос.УстановитьПараметр("Товар",ЭтотОбъект.Товар);
		Рез=Запрос.Выполнить().Выгрузить();
		Если Рез.Количество()<>0 Тогда
			Стр=Рез.Получить(0);
			Сообщить("Уже есть "+Стр.Товар+" единица на сайте "+Стр.ЕИТ_НаСайте+" с коэффициентом "+Стр.К);
			Отказ=Истина;
		КонецЕсли;
	КонецЕсли;	

КонецПроцедуры

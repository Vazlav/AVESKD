﻿
Процедура СправочнаяСлужба() Экспорт
	// Вставить содержимое обработчика.
	запрос=новый запрос;
	ЗАПРОС.Текст="ВЫБРАТЬ
	             |	Базза.Товар.Код КАК КодТовара,
	             |	Базза.Товар.Наименование КАК НаименованиеТовара,
	             |	Базза.Товар.Производитель.Наименование КАК Производитель,
	             |	Базза.Цена КАК Цена,
	             |	СУММА(Базза.Остаток) КАК Остаток,
	             |	Базза.СкладКод КАК КодАптеки
	             |ИЗ
	             |	(ВЫБРАТЬ ПЕРВЫЕ 10000000
	             |		ПартииЖНВЛСОстатки.Склад.Наименование КАК Аптека,
	             |		ПартииЖНВЛСОстатки.Склад.Метро.Ссылка КАК МетроСсылка,
	             |		ПартииЖНВЛСОстатки.Склад.Регион.Ссылка КАК РегионСсылка,
	             |		ПартииЖНВЛСОстатки.Склад.Метро.Наименование КАК Метро,
	             |		ПартииЖНВЛСОстатки.Партия.Наименование КАК Партия,
	             |		ПартииЖНВЛСОстатки.КолвоОстаток КАК Остаток,
	             |		ВЫРАЗИТЬ(ВЫБОР
	             |				КОГДА ПартииЖНВЛСОстатки.КолвоОстаток > 0
	             |					ТОГДА ПартииЖНВЛСОстатки.СуммаРознСНДСОстаток / ПартииЖНВЛСОстатки.КолвоОстаток
	             |				ИНАЧЕ 0
	             |			КОНЕЦ КАК ЧИСЛО(10, 2)) КАК Цена,
	             |		ПартииЖНВЛСОстатки.Товар.ЕдиницаМин.ЕдИзм.Наименование КАК Единица,
	             |		СводноПоАптеке.КолвоОстаток КАК СводноКолвоОстаток,
	             |		ПартииЖНВЛСОстатки.Склад.ТелефонДляСправки КАК ТелефонДляСправки,
	             |		ПартииЖНВЛСОстатки.Склад.Код КАК СкладКод,
	             |		ПартииЖНВЛСОстатки.Склад КАК Склад,
	             |		ПартииЖНВЛСОстатки.Товар КАК Товар
	             |	ИЗ
	             |		РегистрНакопления.ПартииЖНВЛС.Остатки(&Дата, ) КАК ПартииЖНВЛСОстатки
	             |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииЖНВЛС.Остатки КАК СводноПоАптеке
	             |			ПО ПартииЖНВЛСОстатки.Товар = СводноПоАптеке.Товар
	             |				И ПартииЖНВЛСОстатки.Склад = СводноПоАптеке.Склад
	             |	СГРУППИРОВАТЬ ПО
	             |		ПартииЖНВЛСОстатки.Склад.Метро.Ссылка,
	             |		ПартииЖНВЛСОстатки.Склад.Регион.Ссылка,
	             |		ПартииЖНВЛСОстатки.Склад.Наименование,
	             |		ПартииЖНВЛСОстатки.Склад.Метро.Наименование,
	             |		ПартииЖНВЛСОстатки.Партия.Наименование,
	             |		ПартииЖНВЛСОстатки.Товар.ЕдиницаМин.ЕдИзм.Наименование,
	             |		ПартииЖНВЛСОстатки.КолвоОстаток,
	             |		СводноПоАптеке.КолвоОстаток,
	             |		ПартииЖНВЛСОстатки.Склад.ТелефонДляСправки,
	             |		ВЫРАЗИТЬ(ВЫБОР
	             |				КОГДА ПартииЖНВЛСОстатки.КолвоОстаток > 0
	             |					ТОГДА ПартииЖНВЛСОстатки.СуммаРознСНДСОстаток / ПартииЖНВЛСОстатки.КолвоОстаток
	             |				ИНАЧЕ 0
	             |			КОНЕЦ КАК ЧИСЛО(10, 2)),
	             |		ПартииЖНВЛСОстатки.Склад.Код,
	             |		ПартииЖНВЛСОстатки.Склад,
	             |		ПартииЖНВЛСОстатки.Товар
	             |	
	             |	УПОРЯДОЧИТЬ ПО
	             |		Аптека,
	             |		Цена,
	             |		Партия) КАК Базза
	             |ГДЕ
	             |	Базза.Цена > 0
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	Базза.Цена,
	             |	Базза.Единица,
	             |	Базза.СводноКолвоОстаток,
	             |	Базза.СкладКод,
	             |	Базза.Товар.Код,
	             |	Базза.Товар.Наименование,
	             |	Базза.Товар.Производитель.Наименование
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	КодАптеки";
				 
				 ЗАПРОС.УстановитьПараметр("Дата",ТекущаяДата());
							 //ЗаписьXML=Новый ЗаписьXML;
				 //ЗаписьXML.ОткрытьФайл(ПутьКФайлу);
				 ТЗ=ЗАПРОС.Выполнить().Выгрузить();
                 ЗаписьXML=Неопределено;

				 //ЭтотОбъект.ТоварыИОстатки.Очистить();
				 ПутьКФайлу="\\s110\post\spravki\";

				 КодАптеки="";
				 для каждого СТР из ТЗ Цикл
					 если не КодАптеки=стр.КодАптеки тогда
						 	если не ЗаписьXML=Неопределено	 тогда
								ЗаписьXML.ЗаписатьКонецЭлемента();
								ЗаписьXML.Закрыть();
							КонецЕсли;
						 
						 
					ЗаписьXML=Новый ЗаписьXML;
					КодАптеки=стр.КодАптеки;
				 	ЗаписьXML.ОткрытьФайл(ПутьКФайлу+КодАптеки+".xml");
				 	ЗаписьXML.ЗаписатьНачалоЭлемента("ТоварыИОстатки");
					
					КонецЕсли;	 

					ЗаписьXML.ЗаписатьНачалоЭлемента("Товар"); 
					ЗаписатьXML(ЗаписьXML,стр.КодТовара,"Код", НазначениеТипаXML.Неявное);
					ЗаписатьXML(ЗаписьXML,стр.НаименованиеТовара,"Название", НазначениеТипаXML.Неявное);
					ЗаписатьXML(ЗаписьXML,стр.Производитель,"Производитель", НазначениеТипаXML.Неявное);
					ЗаписатьXML(ЗаписьXML,стр.Цена,"Цена", НазначениеТипаXML.Неявное);
					ЗаписатьXML(ЗаписьXML,стр.Остаток,"Количество", НазначениеТипаXML.Неявное);
					ЗаписатьXML(ЗаписьXML,стр.КодАптеки,"НомерАптеки", НазначениеТипаXML.Неявное);
					ЗаписьXML.ЗаписатьКонецЭлемента();
				 КонецЦикла;
				 
				 
				 ЗаписьXML.ЗаписатьКонецЭлемента();
				ЗаписьXML.Закрыть();	 
КонецПроцедуры



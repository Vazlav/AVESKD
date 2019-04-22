﻿Процедура ОчиститьКорзину(НомерКорзины) Экспорт
	
	//---------------<Чистим корзину и все поля на форме>---------------------------// GtG // 29.08.2012 19:36:28
	МенЗап=РегистрыСведений.Корзина.СоздатьНаборЗаписей();
	МенЗап.Отбор["Пользователь"].Установить(ПараметрыСеанса.ТекущийСотр,Истина);
	МенЗап.Отбор["НомерКорзины"].Установить(НомерКорзины,Истина);

    МенЗап.Прочитать();
	МенЗап.Очистить();
	МенЗап.Записать();
КонецПроцедуры

Процедура ДобавитьВКорзину(Склад,Товар,Цена,Количество,ЕИТ,НомерКорзины) Экспорт
	
	МЗ=РегистрыСведений.Корзина.СоздатьМенеджерЗаписи();
	
	МЗ.Пользователь=ПараметрыСеанса.ТекущийСотр;
	МЗ.Склад=Склад;
	МЗ.Товар=Товар;
	МЗ.Цена =Цена;
	МЗ.ЕИТ=ЕИТ;
	МЗ.НомерКорзины=НомерКорзины;
	
	МЗ.Прочитать();
	
	Если МЗ.Выбран()=Истина Тогда // Уже есть запись с такими парамтрами
		// Складываем количество в результирующей
		НовоеКолво=МЗ.Количество+Количество;
	Иначе	
		НовоеКолво=Количество;
	КонецЕсли;
	
	//---------------<Записываем>---------------------------// GtG // 31.08.2012 10:57:46
	
	МЗ.Пользователь=ПараметрыСеанса.ТекущийСотр;
	МЗ.Склад=Склад;
	МЗ.Товар=Товар;
	МЗ.Цена =Цена;
	МЗ.ЕИТ=ЕИТ;
	МЗ.НомерКорзины=НомерКорзины;
    МЗ.Количество=НовоеКолво;
	МЗ.ПроцентСкидки=0; // НЕХ, ибо скидку даем в корзине при окончаельном оформлении заказа
	МЗ.СуммаБезСкидки=Цена* НовоеКолво ;
	МЗ.СуммаСкидки   =0;
	МЗ.СуммаСоСкидкой =МЗ.СуммаБезСкидки;
	
	МЗ.Записать();
	
КонецПроцедуры	


Функция МО_ТекстЗапросаПолученияОстатков(ВнешнийВызов=ложь, ПоказыватьДатуПоследнейПоставки=ложь) Экспорт
	
	ЗапросПоОстаткамТоваров_Текст=  "ВЫБРАТЬ
                                |	ТСписокТоваров.Товар,
                                |	ТСписокТоваров.Количество
                                |ПОМЕСТИТЬ ТСписокТоваров
                                |ИЗ
                                |	&ТСписокТоваров КАК ТСписокТоваров
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ
                                |	МестаХранения.Ссылка КАК Ссылка,
                                |	МестаХранения.Метро КАК Метро,
                                |	МестаХранения.Бренд КАК Бренд,
                                |	МестаХранения.ОсуществляетДоставкуКлиенту,
                                |	МестаХранения.ОсуществляетБронирование,
                                |	МестаХранения.ТелефонДляСправки,
                                |	МестаХранения.РежимРаботы
                                |ПОМЕСТИТЬ ТоргующиеАптеки
                                |ИЗ
                                |	Справочник.МестаХранения КАК МестаХранения
                                |ГДЕ
                                |	МестаХранения.СторонаДоговораКомиссии <> ЗНАЧЕНИЕ(Перечисление.СтороныДоговораКомиссии.Комитент)
                                |	И ВЫБОР
                                |			КОГДА &ОсуществляетДоставкуКлиенту = ЛОЖЬ
                                |				ТОГДА МестаХранения.ОсуществляетДоставкуКлиенту
                                |			ИНАЧЕ &ОсуществляетДоставкуКлиенту
                                |		КОНЕЦ = МестаХранения.ОсуществляетДоставкуКлиенту
                                |	И МестаХранения.ПометкаУдаления = ЛОЖЬ
                                |	И (МестаХранения.ДатаЗакрытия = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
                                |			ИЛИ МестаХранения.ДатаЗакрытия > &ТекущаяДата)
                                |	И МестаХранения.ДатаПерехода < &ТекущаяДата
                                |	И ВЫБОР
                                |			КОГДА &БронированиеПоАптеке = ИСТИНА
                                |				ТОГДА &АптекаБронирования
                                |			ИНАЧЕ МестаХранения.Ссылка
                                |		КОНЕЦ = МестаХранения.Ссылка
                                |
                                |ИНДЕКСИРОВАТЬ ПО
                                |	Ссылка,
                                |	Бренд,
                                |	Метро
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ
                                |	ГруппировкаБрендовДляСССписокБрендовГруппировки.Бренд КАК Бренд
                                |ПОМЕСТИТЬ ВыбраннаяГруппировкаБрендов
                                |ИЗ
                                |	Справочник.ГруппировкаБрендовДляСС.СписокБрендовГруппировки КАК ГруппировкаБрендовДляСССписокБрендовГруппировки
                                |ГДЕ
                                |	ГруппировкаБрендовДляСССписокБрендовГруппировки.Ссылка = &ГруппировкаБрендов
                                |
                                |ИНДЕКСИРОВАТЬ ПО
                                |	Бренд
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ РАЗЛИЧНЫЕ
                                |	ТоргующиеАптеки.Ссылка,
                                |	ВЫБОР
                                |		КОГДА ВыбраннаяГруппировкаБрендов.Бренд ЕСТЬ NULL 
                                |			ТОГДА 0
                                |		ИНАЧЕ 1
                                |	КОНЕЦ КАК Подходит,
                                |	ТоргующиеАптеки.Метро,
                                |	ТоргующиеАптеки.ОсуществляетДоставкуКлиенту,
                                |	ТоргующиеАптеки.ОсуществляетБронирование,
                                |	ТоргующиеАптеки.ТелефонДляСправки,
                                |	ТоргующиеАптеки.РежимРаботы
                                |ПОМЕСТИТЬ АптекиПоБрендуАС
                                |ИЗ
                                |	ТоргующиеАптеки КАК ТоргующиеАптеки
                                |		ЛЕВОЕ СОЕДИНЕНИЕ ВыбраннаяГруппировкаБрендов КАК ВыбраннаяГруппировкаБрендов
                                |		ПО ТоргующиеАптеки.Ссылка.Бренд = ВыбраннаяГруппировкаБрендов.Бренд
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ
                                |	СУММА(АптекиПоБрендуАС.Подходит) КАК Подходит
                                |ПОМЕСТИТЬ АптекПоБренду
                                |ИЗ
                                |	АптекиПоБрендуАС КАК АптекиПоБрендуАС
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ
                                |	АптекиПоБрендуАС.Ссылка КАК Аптека,
                                |	АптекиПоБрендуАС.Метро КАК Метро,
                                |	АптекиПоБрендуАС.ОсуществляетДоставкуКлиенту,
                                |	АптекиПоБрендуАС.ОсуществляетБронирование,
                                |	АптекиПоБрендуАС.ТелефонДляСправки,
                                |	АптекиПоБрендуАС.РежимРаботы
                                |ПОМЕСТИТЬ Аптеки_ОтфильтрованныеПоБрендуАС
                                |ИЗ
                                |	АптекиПоБрендуАС КАК АптекиПоБрендуАС,
                                |	АптекПоБренду КАК АптекПоБренду
                                |ГДЕ
                                |	ВЫБОР
                                |			КОГДА АптекПоБренду.Подходит = 0
                                |				ТОГДА 1
                                |			ИНАЧЕ АптекиПоБрендуАС.Подходит
                                |		КОНЕЦ = 1
                                |
                                |ИНДЕКСИРОВАТЬ ПО
                                |	Аптека,
                                |	Метро
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ ТоргующиеАптеки
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ ВыбраннаяГруппировкаБрендов
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ АптекиПоБрендуАС
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ АптекПоБренду
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ
                                |	МетроПоМаршрутизатору.Метро КАК Метро,
                                |	МетроПоМаршрутизатору.УдаленностьОтКлиента
                                |ПОМЕСТИТЬ МетроФильтр
                                |ИЗ
                                |	&МетроПоМаршрутизатору КАК МетроПоМаршрутизатору
                                |
                                |ИНДЕКСИРОВАТЬ ПО
                                |	Метро
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ
                                |	СУММА(1) КАК ВыбраноСтанций
                                |ПОМЕСТИТЬ СтанцийВФильтреПоМетро
                                |ИЗ
                                |	МетроФильтр КАК МетроФильтр
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ
                                |	АПБ_КФСМ.Аптека КАК Аптека,
                                |	АПБ_КФСМ.Метро КАК Метро,
                                |	ВЫБОР
                                |		КОГДА МетроФильтр.Метро ЕСТЬ NULL 
                                |			ТОГДА 0
                                |		ИНАЧЕ МетроФильтр.УдаленностьОтКлиента
                                |	КОНЕЦ КАК УдаленностьОтКлиента,
                                |	АПБ_КФСМ.ОсуществляетДоставкуКлиенту,
                                |	АПБ_КФСМ.ОсуществляетБронирование,
                                |	АПБ_КФСМ.ТелефонДляСправки,
                                |	АПБ_КФСМ.РежимРаботы
                                |ПОМЕСТИТЬ Аптеки
                                |ИЗ
                                |	(ВЫБРАТЬ РАЗЛИЧНЫЕ
                                |		Аптеки_ОтфильтрованныеПоБрендуАС.Аптека КАК Аптека,
                                |		Аптеки_ОтфильтрованныеПоБрендуАС.Метро КАК Метро,
                                |		СтанцийВФильтреПоМетро.ВыбраноСтанций КАК ВыбраноСтанций,
                                |		Аптеки_ОтфильтрованныеПоБрендуАС.ОсуществляетДоставкуКлиенту КАК ОсуществляетДоставкуКлиенту,
                                |		Аптеки_ОтфильтрованныеПоБрендуАС.ОсуществляетБронирование КАК ОсуществляетБронирование,
                                |		Аптеки_ОтфильтрованныеПоБрендуАС.ТелефонДляСправки КАК ТелефонДляСправки,
                                |		Аптеки_ОтфильтрованныеПоБрендуАС.РежимРаботы КАК РежимРаботы
                                |	ИЗ
                                |		Аптеки_ОтфильтрованныеПоБрендуАС КАК Аптеки_ОтфильтрованныеПоБрендуАС,
                                |		СтанцийВФильтреПоМетро КАК СтанцийВФильтреПоМетро) КАК АПБ_КФСМ
                                |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МетроФильтр КАК МетроФильтр
                                |		ПО (ВЫБОР
                                |				КОГДА АПБ_КФСМ.ВыбраноСтанций = 0
                                |					ТОГДА АПБ_КФСМ.Метро
                                |				ИНАЧЕ МетроФильтр.Метро
                                |			КОНЕЦ = АПБ_КФСМ.Метро)
                                |
                                |ИНДЕКСИРОВАТЬ ПО
                                |	Аптека,
                                |	Метро
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ Аптеки_ОтфильтрованныеПоБрендуАС
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ МетроФильтр
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ СтанцийВФильтреПоМетро
                                |;
                                |
								|////////////////////////////////////////////////////////////////////////////////
								|ВЫБРАТЬ
								|	ПродажиСменККМОбороты.Товар,
								|	ПродажиСменККМОбороты.Склад,
								|	ПродажиСменККМОбороты.Партия,
								|	СУММА(ПродажиСменККМОбороты.КолвоОборот) КАК КолвоОборот
								|ПОМЕСТИТЬ НепроведенныеЧеки
								|ИЗ
								|	РегистрНакопления.ПродажиСменККМ.Обороты(
								|			,
								|			,
								|			,
								|			Товар В (&СписокТоваров)
								|				И Склад В
								|					(ВЫБРАТЬ
								|						А.Аптека
								|					ИЗ
								|						Аптеки КАК А)) КАК ПродажиСменККМОбороты
								|
								|СГРУППИРОВАТЬ ПО
								|	ПродажиСменККМОбороты.Партия,
								|	ПродажиСменККМОбороты.Склад,
								|	ПродажиСменККМОбороты.Товар
								|;
								|
								|////////////////////////////////////////////////////////////////////////////////
								|ВЫБРАТЬ РАЗЛИЧНЫЕ
								|	ПартииЖНВЛСОбороты.Товар,
								|	ПартииЖНВЛСОбороты.Склад,
								|	ПартииЖНВЛСОбороты.Партия
								|ПОМЕСТИТЬ НеоприходованныеПартии
								|ИЗ
								|	РегистрНакопления.ПартииЖНВЛС.Обороты(
								|			ДобавитьКДате(&ТекущаяДата, Месяц, -1),
								|			&ТекущаяДата,
								|			Регистратор,
								|			Товар В (&СписокТоваров)
								|				И Склад В
								|					(ВЫБРАТЬ
								|						А.Аптека
								|					ИЗ
								|						Аптеки КАК А)) КАК ПартииЖНВЛСОбороты
								|ГДЕ
								|	ПартииЖНВЛСОбороты.Регистратор ССЫЛКА Документ.ПоступлениеТовара
								|	И ВЫРАЗИТЬ(ПартииЖНВЛСОбороты.Регистратор КАК Документ.ПоступлениеТовара).ДатапоступленияНаСклад = ДАТАВРЕМЯ(1, 1, 1)
								|; 		
								|
								|////////////////////////////////////////////////////////////////////////////////
								|ВЫБРАТЬ
								|	Аптеки.Аптека,
                                |	Аптеки.Метро,
                                |	Аптеки.УдаленностьОтКлиента,
                                |	ПартииЖНВЛСОстатки.Товар,
								|	ПартииЖНВЛСОстатки.Партия,
								|	ВЫБОР
								|		КОГДА ПартииЖНВЛСОстатки.КолвоОстаток - ЕСТЬNULL(НепроведенныеЧеки.КолвоОборот, 0) < 0
								|			ТОГДА 0
								|		ИНАЧЕ ПартииЖНВЛСОстатки.КолвоОстаток - ЕСТЬNULL(НепроведенныеЧеки.КолвоОборот, 0)
								|	КОНЕЦ КАК КолвоОстаток,								
								|	ПартииЖНВЛСОстатки.СуммаЗакупСНДСОстаток,
								|	ПартииЖНВЛСОстатки.СуммаРознСНДСОстаток,
								|	1 КАК ИсточникДанных,
                                |	Аптеки.ОсуществляетДоставкуКлиенту,
                                |	Аптеки.ОсуществляетБронирование,
                                |	Аптеки.ТелефонДляСправки,
                                |	Аптеки.РежимРаботы
                                |ПОМЕСТИТЬ ПоОстаткам
                                |ИЗ
                                |	РегистрНакопления.ПартииЖНВЛС.Остатки(
                                |			,
                                |			Товар В (&СписокТоваров)
                                |				И Склад В
                                |					(ВЫБРАТЬ
                                |						А.Аптека
                                |					ИЗ
                                |						Аптеки КАК А)) КАК ПартииЖНВЛСОстатки
								|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Аптеки КАК Аптеки
								|		ПО ПартииЖНВЛСОстатки.Склад = Аптеки.Аптека
								|		ЛЕВОЕ СОЕДИНЕНИЕ НепроведенныеЧеки КАК НепроведенныеЧеки
								|		ПО ПартииЖНВЛСОстатки.Товар = НепроведенныеЧеки.Товар
								|			И ПартииЖНВЛСОстатки.Склад = НепроведенныеЧеки.Склад
								|			И ПартииЖНВЛСОстатки.Партия = НепроведенныеЧеки.Партия
								|		ЛЕВОЕ СОЕДИНЕНИЕ НеоприходованныеПартии КАК НеоприходованныеПартии
								|		ПО ПартииЖНВЛСОстатки.Товар = НеоприходованныеПартии.Товар
								|			И ПартииЖНВЛСОстатки.Склад = НеоприходованныеПартии.Склад
								|			И ПартииЖНВЛСОстатки.Партия = НеоприходованныеПартии.Партия
								|ГДЕ
								|	ПартииЖНВЛСОстатки.КолвоОстаток - ЕСТЬNULL(НепроведенныеЧеки.КолвоОборот, 0) > 0 								
								|	И НеоприходованныеПартии.Партия ЕСТЬ NULL
								|;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ НепроведенныеЧеки
                                |;
								|
								|////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ НеоприходованныеПартии
                                |;
								|
								|////////////////////////////////////////////////////////////////////////////////
								|ВЫБРАТЬ
								|		ВременнаяБлокировкаТоваровДляСС.Товар,
								|		ВременнаяБлокировкаТоваровДляСС.Партия,
								|		ВременнаяБлокировкаТоваровДляСС.Склад как Аптека
								|   Into БлокированныйТоварПоАптекам
								|	ИЗ
								|		РегистрСведений.ВременнаяБлокировкаТоваровДляСС КАК ВременнаяБлокировкаТоваровДляСС
								|	ГДЕ
								|		НАЧАЛОПЕРИОДА(&ТекущаяДата, ДЕНЬ) МЕЖДУ ВременнаяБлокировкаТоваровДляСС.НачалоБлокировки И ВременнаяБлокировкаТоваровДляСС.КонецБлокировки
								|		И ВременнаяБлокировкаТоваровДляСС.Товар В(&СписокТоваров)
								|;
								|////////////////////////////////////////////////////////////////////////////////
								|	ВЫБРАТЬ
								|		ПоОстаткам.Аптека КАК Аптека,
								|		ПоОстаткам.Метро КАК Метро,
								|		ПоОстаткам.УдаленностьОтКлиента КАК УдаленностьОтКлиента,
                                |		ПоОстаткам.Товар КАК Товар,
                                |		ПоОстаткам.Партия КАК Партия,
                                |		ПоОстаткам.КолвоОстаток КАК Количество,
                                |		ПоОстаткам.СуммаЗакупСНДСОстаток КАК СуммаЗакуп,
                                |		ПоОстаткам.СуммаРознСНДСОстаток КАК СуммаРозн,
                                |		ПоОстаткам.ИсточникДанных КАК ИсточникДанных,
                                |		ПоОстаткам.ОсуществляетДоставкуКлиенту КАК ОсуществляетДоставкуКлиенту,
                                |		ПоОстаткам.ОсуществляетБронирование КАК ОсуществляетБронирование,
                                |		ПоОстаткам.ТелефонДляСправки КАК ТелефонДляСправки,
                                |		ПоОстаткам.РежимРаботы КАК РежимРаботы
								|       ПОМЕСТИТЬ ВТТовар                           
                                |	ИЗ
                                |		ПоОстаткам КАК ПоОстаткам 
								|      левое соединение  
								|       БлокированныйТоварПоАптекам как БлокированныйТоварПоАптекам
								|       on  ПоОстаткам.Аптека=БлокированныйТоварПоАптекам.Аптека 
								|       and ПоОстаткам.Товар=БлокированныйТоварПоАптекам.Товар
								|       and ПоОстаткам.Партия=БлокированныйТоварПоАптекам.Партия
								|   where
								|        БлокированныйТоварПоАптекам.Товар is null 
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ
                                |	АптекиСКолвомТовара.Аптека,
                                |	АптекиСКолвомТовара.Товар
                                |ПОМЕСТИТЬ ФильтрПоКолвуОстаткаПоСпискуТоваров
                                |ИЗ
                                |	(ВЫБРАТЬ
                                |		ВТТовар.Аптека КАК Аптека,
                                |		ВТТовар.Товар КАК Товар,
                                |		СУММА(ВТТовар.Количество) КАК Количество
                                |	ИЗ
                                |		ВТТовар КАК ВТТовар
                                |	
                                |	СГРУППИРОВАТЬ ПО
                                |		ВТТовар.Аптека,
                                |		ВТТовар.Товар) КАК АптекиСКолвомТовара
                                |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТСписокТоваров КАК ТСписокТоваров
                                |		ПО АптекиСКолвомТовара.Товар = ТСписокТоваров.Товар
                                |ГДЕ
                                |	АптекиСКолвомТовара.Количество >= ТСписокТоваров.Количество
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ
								|	ВТТовар.Аптека.Код как КодАптеки,
                                |	ВТТовар.Аптека"+?(ВнешнийВызов=Истина,".Код","")+" как Аптека,
                                |	ВТТовар.Метро"+?(ВнешнийВызов=Истина,".Код","")+" как Метро,
                                |	ВТТовар.УдаленностьОтКлиента как УдаленностьОтКлиента,
                                |	ВТТовар.Товар как Товар,
                                |	ВТТовар.Партия как Партия,
                                |	ВТТовар.Количество как Количество,
                                |	ВТТовар.СуммаЗакуп как СуммаЗакуп,
                                |	ВТТовар.СуммаРозн как СуммаРозн,
                                |	ВТТовар.ИсточникДанных как ИсточникДанных,
                                |	ВТТовар.ОсуществляетДоставкуКлиенту как ОсуществляетДоставкуКлиенту,
                                |	ВТТовар.ОсуществляетБронирование как ОсуществляетБронирование,
                                |	ВТТовар.ТелефонДляСправки как ТелефонДляСправки,
                                |	ВТТовар.РежимРаботы.наименование как РежимРаботы
                                |ПОМЕСТИТЬ ВтТовар1
                                |ИЗ
                                |	ВТТовар КАК ВТТовар
                                |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ФильтрПоКолвуОстаткаПоСпискуТоваров КАК ФильтрПоКолвуОстаткаПоСпискуТоваров
                                |		ПО ВТТовар.Аптека = ФильтрПоКолвуОстаткаПоСпискуТоваров.Аптека
                                |			И ВТТовар.Товар = ФильтрПоКолвуОстаткаПоСпискуТоваров.Товар
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ ВТТовар
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ
                                |	ВтТовар1.Аптека,
                                |	ВтТовар1.Товар,
                                |	СУММА(ВтТовар1.Количество) КАК Количество
                                |ПОМЕСТИТЬ ФильтрПоМинОстатку
                                |ИЗ
                                |	ВтТовар1 КАК ВтТовар1
                                |
                                |СГРУППИРОВАТЬ ПО
                                |	ВтТовар1.Аптека,
                                |	ВтТовар1.Товар
                                |
                                |ИМЕЮЩИЕ
                                |	СУММА(ВтТовар1.Количество) >= &МинОстаток
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |ВЫБРАТЬ
                                |	КолваНаименованийПоАптекам.Аптека
                                |ПОМЕСТИТЬ ДопФильтрНаСписокТоваровПоАптекам
                                |ИЗ
                                |	(ВЫБРАТЬ
                                |		ВтТовар1.Аптека КАК Аптека,
                                |		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВтТовар1.Товар) КАК КолвоНаименованийПоАптеке
                                |	ИЗ
                                |		ВтТовар1 КАК ВтТовар1
                                |	
                                |	СГРУППИРОВАТЬ ПО
                                |		ВтТовар1.Аптека) КАК КолваНаименованийПоАптекам,
                                |	(ВЫБРАТЬ
                                |		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ АССОРТИМЕНТНЫЙ_ПЛАН.Ссылка) КАК КолвоНаименованийВСписке
                                |	ИЗ
                                |		Справочник.АССОРТИМЕНТНЫЙ_ПЛАН КАК АССОРТИМЕНТНЫЙ_ПЛАН
                                |	ГДЕ
                                |		АССОРТИМЕНТНЫЙ_ПЛАН.Ссылка В(&СписокТоваров)) КАК РазмерСпискаТоваров
                                |ГДЕ
                                |	КолваНаименованийПоАптекам.КолвоНаименованийПоАптеке = РазмерСпискаТоваров.КолвоНаименованийВСписке
								|;
								|"
								+ ?(ПоказыватьДатуПоследнейПоставки,
								"////////////////////////////////////////////////////////////////////////////////
								|ВЫБРАТЬ
								|	ПартииЖНВЛСОбороты.Товар,
								|	ПартииЖНВЛСОбороты.Склад,
								|	МАКСИМУМ(ПартииЖНВЛСОбороты.Период) КАК Период
								|ПОМЕСТИТЬ ПоследниеПоступления
								|ИЗ
								|	РегистрНакопления.ПартииЖНВЛС.Обороты(
								|			ДобавитьКДате(&ТекущаяДата, МЕСЯЦ, -1),
								|			&ТекущаяДата,
								|			Регистратор,
								|			Товар В (&СписокТоваров)
								|				И Склад В
								|					(ВЫБРАТЬ
								|						А.Аптека
								|					ИЗ
								|						Аптеки КАК А)) КАК ПартииЖНВЛСОбороты
								|ГДЕ
								|	ПартииЖНВЛСОбороты.Регистратор ССЫЛКА Документ.ПоступлениеТовара
								|
								|СГРУППИРОВАТЬ ПО
								|	ПартииЖНВЛСОбороты.Товар,
								|	ПартииЖНВЛСОбороты.Склад
								|;
								|", "") + 
								"////////////////////////////////////////////////////////////////////////////////
								|ВЫБРАТЬ
								|	ВтТовар1.КодАптеки КАК КодАптеки,
                                |	ВтТовар1.Аптека КАК Аптека,
                                |	ВтТовар1.Метро,
                                |	ВЫБОР
                                |		КОГДА ВтТовар1.ИсточникДанных = 1
                                |			ТОГДА ВтТовар1.Количество / ВтТовар1.Товар.ЕдиницаПоУмолчанию.К
                                |		ИНАЧЕ 0
                                |	КОНЕЦ КАК Остаток,
                                |	ВтТовар1.СуммаРозн / ВтТовар1.Количество * ВтТовар1.Товар.Коэффициент КАК Цена,
                                |	ВтТовар1.Товар.ЕдиницаПоУмолчанию"+?(ВнешнийВызов=Истина,".наименование","")+" КАК ЕИТ,
                                |	ВтТовар1.ТелефонДляСправки,
                                |	ВтТовар1.РежимРаботы,
                                |	ВЫРАЗИТЬ(ВтТовар1.СуммаЗакуп / ВтТовар1.Количество * ВтТовар1.Товар.Коэффициент * 1.04 КАК ЧИСЛО(10, 1)) КАК Мин_Розн_Цена,
                                |	ВтТовар1.Товар.Коэффициент КАК К,
                                |	ВтТовар1.ОсуществляетДоставкуКлиенту КАК Доставка,
                                |	ВтТовар1.ОсуществляетБронирование КАК ОсуществляетБронирование,
                                |	ВтТовар1.УдаленностьОтКлиента КАК УдаленностьОтКлиента,
								|	ВтТовар1.Партия,
                                |	ВтТовар1.Партия.Производитель"+?(ВнешнийВызов=Истина,".Наименование","")+" КАК Производитель,"
								+ ?(ПоказыватьДатуПоследнейПоставки, "ЕстьNull(ПоследниеПоступления.Период, ВтТовар1.Партия.ДатаПоступления) КАК ПоследняяПоставка,", "") +
								"ВтТовар1.Товар"+?(ВнешнийВызов=Истина,".Код","")+" КАК Товар 								
                                |ИЗ
                                |	ВтТовар1 КАК ВтТовар1
                                |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ФильтрПоМинОстатку КАК ФильтрПоМинОстатку
                                |		ПО ВтТовар1.Аптека = ФильтрПоМинОстатку.Аптека
                                |			И ВтТовар1.Товар = ФильтрПоМинОстатку.Товар"
								+ ?(ПоказыватьДатуПоследнейПоставки, " ЛЕВОЕ СОЕДИНЕНИЕ ПоследниеПоступления КАК ПоследниеПоступления ПО ВтТовар1.Аптека = ПоследниеПоступления.Склад И ВтТовар1.Товар = ПоследниеПоступления.Товар ", " ") +
                                "ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДопФильтрНаСписокТоваровПоАптекам КАК ДопФильтрНаСписокТоваровПоАптекам
                                |		ПО ВтТовар1.Аптека = ДопФильтрНаСписокТоваровПоАптекам.Аптека
                                |
                                |УПОРЯДОЧИТЬ ПО
                                |	Товар,
                                |	УдаленностьОтКлиента,
                                |	Аптека,
                                |	Цена
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ Аптеки
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ ДопФильтрНаСписокТоваровПоАптекам
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ ПоОстаткам
                                |;
                                |
                                |////////////////////////////////////////////////////////////////////////////////
                                |УНИЧТОЖИТЬ ФильтрПоМинОстатку";
								
								
	Возврат ЗапросПоОстаткамТоваров_Текст;
	
КонецФункции	
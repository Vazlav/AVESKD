﻿
Перем мРедактируемаяЗапись Экспорт;

Перем мФормаВладелец;

Перем мВозвратСтруктуры Экспорт;

#Если Клиент Тогда

// Функция обрабатывает событие закрытия формы редактирования записи.
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Булево - Закрывать или не закрывать форму
//
Функция ЗакрыватьФормуРедактирования(Записывать = Истина, СохранятьДанные = Истина) Экспорт

	ОтветНаВопрос = Вопрос("Данные были изменены. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Отмена Тогда
		СохранятьДанные = Ложь;
		Возврат Истина;
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		Если Записывать Тогда
			Возврат НЕ Записать();
		Иначе
			Возврат Ложь;
		КонецЕсли; 
	Иначе
		СохранятьДанные = Ложь;
		Возврат Ложь;
	КонецЕсли; 

КонецФункции

// Функция определяет имя формы в зависимости от типа КИ.
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Строка - Имя формы
//
Функция ПолучитьИмяФормы()

	Если Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
		Возврат "ФормаЗаписиАдреса";
	ИначеЕсли Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
		Возврат "ФормаЗаписиАдресаЭП";
	ИначеЕсли Тип = Перечисления.ТипыКонтактнойИнформации.ВебСтраница Тогда
		Возврат "ФормаЗаписиВебСтраницы";
	ИначеЕсли Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
		Возврат "ФормаЗаписиТелефона";
	Иначе
		Возврат "ФормаЗаписи";
	КонецЕсли;

КонецФункции

// Процедура инициирует редактирование записи.
//
// Параметры:
//  СтруктураЗаписи - Структура, НаборЗаписейРегистраСведений, МенеджерЗаписи, ЗаписьНабораЗаписей
//                    Данные для редактирования
//  Записывать      - Булево, Записывать данные в ИД при окончании редактирования
//  ФормаВладелец   - Форма, откуда вызывается редактирование
//  СтруктураПредустановленныхЗначений - Структура, данные для заполнения форма по умолчанию,
//                    могут отличаться от редактируемых, например при копировании
//
Процедура РедактироватьЗапись(СтруктураЗаписи = Неопределено, Записывать = Ложь, ФормаВладелец = Неопределено, СтруктураПредустановленныхЗначений = Неопределено, ОткрыватьМодально = Ложь) Экспорт

	ЗаписыватьВРегистр = Записывать;
	мФормаВладелец = ФормаВладелец;
	
	Если ТипЗнч(СтруктураЗаписи) = Тип("РегистрСведенийЗапись.КонтактнаяИнформация")
	 ИЛИ ТипЗнч(СтруктураЗаписи) = Тип("РегистрСведенийМенеджерЗаписи.КонтактнаяИнформация") Тогда
		мРедактируемаяЗапись = СтруктураЗаписи;
		ЛокальнаяСтруктураЗаписи = УправлениеКонтактнойИнформацией.ПолучитьСтруктуруЗаписиРегистра(СтруктураЗаписи);
	ИначеЕсли ТипЗнч(СтруктураЗаписи) = Тип("РегистрСведенийНаборЗаписей.КонтактнаяИнформация") Тогда
		// Значит вводим нового
		Если СтруктураЗаписи.Отбор.Объект.Использование = Истина И СтруктураЗаписи.Отбор.Объект.Значение <> Неопределено Тогда
			ЛокальнаяСтруктураЗаписи = Новый Структура("Объект", СтруктураЗаписи.Отбор.Объект.Значение);
			мРедактируемаяЗапись = СтруктураЗаписи;
		КонецЕсли; 
	ИначеЕсли ТипЗнч(СтруктураЗаписи) = Тип("Структура") Тогда
		ЛокальнаяСтруктураЗаписи = СтруктураЗаписи;
	КонецЕсли;
	
	Если СтруктураПредустановленныхЗначений <> Неопределено Тогда
		ЛокальнаяСтруктураЗаписи = СтруктураПредустановленныхЗначений;
	КонецЕсли; 
	
	Если ТипЗнч(ЛокальнаяСтруктураЗаписи) = Тип("Структура") Тогда
		Для каждого ЭлементСтруктуры Из ЛокальнаяСтруктураЗаписи Цикл
			ЭтотОбъект[ЭлементСтруктуры.Ключ] = ЭлементСтруктуры.Значение;
		КонецЦикла; 
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Тип) Тогда
	
		Меню = Новый СписокЗначений();

		Для а = 0 По (Перечисления.ТипыКонтактнойИнформации.Количество()-1) Цикл
			Меню.Добавить(Перечисления.ТипыКонтактнойИнформации[а], Перечисления.ТипыКонтактнойИнформации[а]);
		КонецЦикла; 

		ВыбранныйПункт = Меню.ВыбратьЭлемент("Выберите тип контактной информации");

		Если ВыбранныйПункт = Неопределено Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;

		Тип = ВыбранныйПункт.Значение;
	
	КонецЕсли;
	
	Если ОткрыватьМодально Тогда
		ПолучитьФорму(ПолучитьИмяФормы(),мФормаВладелец).ОткрытьМодально();
	Иначе
		ПолучитьФорму(ПолучитьИмяФормы(),мФормаВладелец).Открыть();
	КонецЕсли;

КонецПроцедуры

// Процедура заполняет запись данными из реквизитов обработки.
//
// Параметры:
//  Запись - Менеджер записи или запись из набора
//
Процедура ЗаполнитьЗапись(Запись)

	Запись.Объект        = Объект;
	Запись.Тип           = Тип;
	Запись.Вид           = Вид;
	Запись.Представление = Представление;
	Запись.Комментарий   = Комментарий;
	Для а = 1 По 10 Цикл
		Запись["Поле" + Строка(а)] = ЭтотОбъект["Поле" + Строка(а)];
	КонецЦикла;
	
	Запись.ТипДома     = ТипДома;
	Запись.ТипКорпуса  = ТипКорпуса;
	Запись.ТипКвартиры = ТипКвартиры;

КонецПроцедуры

// Функция производит запись данных в ИБ или просто в запись набора или менеджер записи.
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Булево - Удачно произведена запись или нет.
//
Функция Записать() Экспорт
	
	Если Не ЗначениеЗаполнено(Вид) Тогда
		Сообщить("Не заполнен вид контактной информации.");
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		
		Если ТипЗнч(мФормаВладелец) = Тип("Форма") И Метаданные.Справочники.Содержит(мФормаВладелец.ЭтотОбъект.Метаданные()) Тогда
			
			//Если Не мФормаВладелец.ЭтотОбъект.Заблокирован() Тогда
			//	Попытка
			//		мФормаВладелец.ЭтотОбъект.Заблокировать();
			//	Исключение
			//		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, "Не удалось записать данные о контактной информации.");
			//		Возврат Ложь;
			//	КонецПопытки;
			//КонецЕсли; 
			
			мФормаВладелец.Модифицированность = Истина;
			
		КонецЕсли;
		
	Исключение
		
	КонецПопытки;
	
	
	Если ТипЗнч(мРедактируемаяЗапись) = Тип("РегистрСведенийЗапись.КонтактнаяИнформация")
	 ИЛИ ТипЗнч(мРедактируемаяЗапись) = Тип("РегистрСведенийМенеджерЗаписи.КонтактнаяИнформация") Тогда
		ЗаполнитьЗапись(мРедактируемаяЗапись);
		СтруктураОповещения = Новый Структура("Объект,Тип,Вид", мРедактируемаяЗапись.Объект, мРедактируемаяЗапись.Тип, мРедактируемаяЗапись.Вид);
	ИначеЕсли ТипЗнч(мРедактируемаяЗапись) = Тип("РегистрСведенийНаборЗаписей.КонтактнаяИнформация") Тогда
		// Поищем существующую, если найдем - перепишем ее, если нет - введем новую
		НайденнаяЗаписьНабора = Неопределено;
		Для каждого ЗаписьНабора Из мРедактируемаяЗапись Цикл
			Если ЗаписьНабора.Объект = Объект
			   И ЗаписьНабора.Тип = Тип
			   И ЗаписьНабора.Вид = Вид Тогда
				НайденнаяЗаписьНабора = ЗаписьНабора;
			КонецЕсли; 
		КонецЦикла;
		Если НайденнаяЗаписьНабора = Неопределено Тогда
			НайденнаяЗаписьНабора = мРедактируемаяЗапись.Добавить();
		КонецЕсли; 
		ЗаполнитьЗапись(НайденнаяЗаписьНабора);
		СтруктураОповещения = Новый Структура("Объект,Тип,Вид", НайденнаяЗаписьНабора.Объект, НайденнаяЗаписьНабора.Тип, НайденнаяЗаписьНабора.Вид);
	КонецЕсли;
	
	Если ЗаписыватьВРегистр
	   И ТипЗнч(мРедактируемаяЗапись) = Тип("РегистрСведенийМенеджерЗаписи.КонтактнаяИнформация") Тогда
		Попытка
			мРедактируемаяЗапись.Записать(Ложь);
		Исключение
			Сообщить(ОписаниеОшибки() + " Не удалось записать данные о контактной информации.");
			Возврат Ложь;
		КонецПопытки;
	КонецЕсли; 
	
	Если ТипЗнч(мФормаВладелец) = Тип("Форма") И ТипЗнч(СтруктураОповещения) = Тип("Структура") Тогда
		Оповестить("ЗаписанаКИ", СтруктураОповещения);
	КонецЕсли; 
	
	Возврат Истина;

КонецФункции // Записать()

// Процедура модального редактирования адреса
Процедура РедактироватьМодальноЭлементАдресаРазделенногоЗапятыми(Элемент, ЭтаФорма = Неопределено, КлючФормы = Неопределено) Экспорт
	
	ФормаРедактированияАдреса = ПолучитьФорму("ФормаЗаписиАдреса", ЭтаФорма, КлючФормы);
	
	СтрАдрес = Элемент.Значение;
	СтруктураАдреса = УправлениеКонтактнойИнформацией.ПолучитьСтруктуруАдресаИзСтроки(СтрАдрес);
	УправлениеКонтактнойИнформацией.ЗаполнитьОбъектРедактированияАдресаПоСтруктуре(ЭтотОбъект, СтруктураАдреса);
		
	ДоступностьОбъекта = Ложь;
	Вид = "Адрес разделенный запятыми";
	
	ФормаРедактированияАдреса.ЭлементыФормы.ПолеТипДома.ТолькоПросмотр     = Истина;
	ФормаРедактированияАдреса.ЭлементыФормы.ПолеТипКорпуса.ТолькоПросмотр  = Истина;
	ФормаРедактированияАдреса.ЭлементыФормы.ПолеТипКвартиры.ТолькоПросмотр = Истина;
	
	РезультатРедактирования = ФормаРедактированияАдреса.ОткрытьМодально();
	
	Если РезультатРедактирования <> Неопределено Тогда
		СтрАдрес = УправлениеКонтактнойИнформацией.ПолучитьПолныйАдрес(ЭтотОбъект);
		Элемент.Значение = СтрАдрес;
	КонецЕсли;
	
КонецПроцедуры

Процедура СвернутьПанельПриНеобходимости(ЭтаФорма, ПанельОбъектаИВида) Экспорт

	Если Не ДоступностьОбъекта И ЗначениеЗаполнено(Вид) Тогда
		ПанельОбъектаИВида.Свертка = РежимСверткиЭлементаУправления.Верх;
		ЭтаФорма.Высота = ЭтаФорма.Высота - ПанельОбъектаИВида.Высота;
	КонецЕсли;
	
	ЗадатьЗаголовокФормы(ЭтаФорма);

КонецПроцедуры

Процедура ЗадатьЗаголовокФормы(ЭтаФорма) Экспорт

	НомерКартинки = 0;
	
	Если ЗначениеЗаполнено(Вид) Тогда
		ЭтаФорма.Заголовок = Вид;
		Если ТипЗнч(Вид) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
			НомерКартинки = Вид.НомерКартинки;
		КонецЕсли;
	КонецЕсли;
	
	Картинка = УправлениеКонтактнойИнформацией.ПолучитьКартинкуПоТипу(Тип, НомерКартинки);
	Если Картинка <> Неопределено Тогда
		ЭтаФорма.КартинкаЗаголовка = Картинка;
	КонецЕсли;
	
	Если ОтключитьКнопкуЗаписать Тогда
		КнопкаЗаписать = ЭтаФорма.ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Записать;
		ЭтаФорма.ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить(КнопкаЗаписать);
	КонецЕсли;
	
	Если ТолькоПросмотрФормы Тогда
		КнопкаОК = ЭтаФорма.ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК;
		ЭтаФорма.ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить(КнопкаОК);
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры



#КонецЕсли

Процедура НайтиЗаписиВКИПоИндексу(Индекс, НайденныйРегион, НайденныйРайон) Экспорт
	
	// Очистим таблицу
	НайденныеЗаписиПоИндексу.Очистить();
	
	// Проверим правильность ввода индекса
	Если (СтрДлина(Индекс) <> 6) ИЛИ (УправлениеКонтактнойИнформацией.ЕстьНеЦифры(Индекс)) Тогда
		Возврат;
	КонецЕсли;
	
	// Найдем записи по индексу
	Запрос = Новый Запрос;
	Запрос.Текст = 	"ВЫБРАТЬ
	               	|	АдресныйКлассификатор.ТипАдресногоЭлемента,
	               	|	АдресныйКлассификатор.Код,
	               	|	АдресныйКлассификатор.Наименование + "" "" + АдресныйКлассификатор.Сокращение Как Наименование
	               	|ИЗ
	               	|	РегистрСведений.АдресныйКлассификатор КАК АдресныйКлассификатор
	               	|ГДЕ
	               	|	АдресныйКлассификатор.Индекс = &Индекс";
	Запрос.УстановитьПараметр("Индекс", Индекс);
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Если ничего не нашли
	Если Выборка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Запомним наименования найденных записей 
	ТипПоКоду = Новый Соответствие;
	ИмяПоКоду = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		ТипАдресногоЭлемента = Выборка.ТипАдресногоЭлемента;
		Код = Выборка.Код;
		
		Если ТипАдресногоЭлемента < 6 Тогда
			// не дом
			ИмяПоКоду.Вставить(Код, СокрП(Выборка.Наименование));
		КонецЕсли;
		
		ТипПоКоду.Вставить(Код, ТипАдресногоЭлемента);
	КонецЦикла;
	
	// Определим коды объектов, наименования которых нужно найти
	мНужноИскать = Новый Массив;
	сНужноИскать = Новый Соответствие;
	
	Для Каждого Найденный Из ТипПоКоду Цикл
		ТипАдресногоЭлемента = Найденный.Значение;
		Код = Найденный.Ключ;
		
		Пока ТипАдресногоЭлемента > 1 Цикл
			ТипАдресногоЭлемента = ТипАдресногоЭлемента - 1;
			Маска = УправлениеКонтактнойИнформацией.ПолучитьМаскуПоТипу(ТипАдресногоЭлемента);
			Код = Код - (Код % Маска);
			
			Если (ТипПоКоду.Получить(Код) = Неопределено) И (сНужноИскать.Получить(Код) = Неопределено) Тогда
				сНужноИскать.Вставить(Код, ТипАдресногоЭлемента);
				мНужноИскать.Добавить(Код);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Получим недостающие наименования
	Если мНужноИскать.Количество() <> 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	АдресныйКлассификатор.ТипАдресногоЭлемента,
		               |	АдресныйКлассификатор.Код,
		               |	АдресныйКлассификатор.Наименование + "" "" + АдресныйКлассификатор.Сокращение Как Наименование
		               |ИЗ
		               |	РегистрСведений.АдресныйКлассификатор КАК АдресныйКлассификатор
		               |ГДЕ
		               |	АдресныйКлассификатор.Код В(&масКодов)";
		Запрос.УстановитьПараметр("масКодов", мНужноИскать);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ИмяПоКоду.Вставить(Выборка.Код, СокрП(Выборка.Наименование));
			ТипПоКоду.Вставить(Выборка.Код, Выборка.ТипАдресногоЭлемента);
		КонецЦикла;
	КонецЕсли;
	
	// Определим какие не нужно выводить записи и какие есть различные регионы и районы
	ВсеРегионы = Новый Соответствие;
	ВсеРайоны  = Новый Соответствие;
	НеВыводитьВТаблицу = Новый Соответствие;

	Для Каждого Элемент Из ТипПоКоду Цикл
		ТипАдресногоЭлемента = Элемент.Значение;
		Код = Элемент.Ключ;
		
		Если ТипАдресногоЭлемента = 1 Тогда
			ВсеРегионы.Вставить(Код, Истина);
			НайденныйРегион = Код;
			
		ИначеЕсли ТипАдресногоЭлемента = 2 Тогда
			ВсеРайоны.Вставить(Код, Истина);
			НайденныйРайон = Код;
			
		КонецЕсли;
		
		Если ТипАдресногоЭлемента = 6 Тогда
			Продолжить;
		КонецЕсли;
		
		Пока ТипАдресногоЭлемента > 1 Цикл
			ТипАдресногоЭлемента = ТипАдресногоЭлемента - 1;
			Маска = УправлениеКонтактнойИнформацией.ПолучитьМаскуПоТипу(ТипАдресногоЭлемента);
			Код = Код - (Код % Маска);
			НеВыводитьВТаблицу.Вставить(Код, Истина);
		КонецЦикла;
	КонецЦикла;
	
	НайденныйРегион = ?(ВсеРегионы.Количество() = 1, ИмяПоКоду.Получить(НайденныйРегион), "");
	НайденныйРайон  = ?(ВсеРайоны.Количество()  = 1, ИмяПоКоду.Получить(НайденныйРайон),  "");
	
	// Определим уровень детализации выводимой информации о городе / населенном пункте
	Если ВсеРегионы.Количество() > 1 Тогда
		ДетализацияДоУровня = 1;
	ИначеЕсли ВсеРайоны.Количество() > 1 Тогда
		ДетализацияДоУровня = 2;
	Иначе
		ДетализацияДоУровня = 3;
	КонецЕсли;
	
	// Заполним таблицу с найденными записями
	Для Каждого Элемент Из ТипПоКоду Цикл
		ТипАдресногоЭлемента = Элемент.Значение;
		Код = Элемент.Ключ;
		
		Если (ТипАдресногоЭлемента = 6) ИЛИ (НеВыводитьВТаблицу.Получить(Код) <> Неопределено) Тогда
			Продолжить;
		КонецЕсли;
		
		новСтр = НайденныеЗаписиПоИндексу.Добавить();
		новСтр.Улица    = ?(ТипАдресногоЭлемента = 5, ИмяПоКоду.Получить(Код), "< Без улицы >");
		новСтр.Код      = Код;
		новСтр.Описание = "";
		
		// Получим описание
		ТипАдресногоЭлемента = ?(ТипАдресногоЭлемента = 5, 4, ТипАдресногоЭлемента);
		Пока ТипАдресногоЭлемента >= ДетализацияДоУровня Цикл
			Код = Код - (Код % УправлениеКонтактнойИнформацией.ПолучитьМаскуПоТипу(ТипАдресногоЭлемента));
			Если УправлениеКонтактнойИнформацией.ПолучитьТипАдресногоЭлемента(Код) = ТипАдресногоЭлемента Тогда
				новСтр.Описание = новСтр.Описание + ?(новСтр.Описание = "", "", ", ") + ИмяПоКоду.Получить(Код);
			КонецЕсли;
			
			ТипАдресногоЭлемента = ТипАдресногоЭлемента - 1;
		КонецЦикла;
	КонецЦикла;
	
	НайденныеЗаписиПоИндексу.Сортировать("Улица, Код");
	
КонецПроцедуры


ДоступностьОбъекта = Истина;
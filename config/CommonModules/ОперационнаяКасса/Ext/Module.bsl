﻿Функция ПолучитьУпаковкиОперКассы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	АптекаОфис.Код КАК Код,
	               |	АптекаОфис.ТипУпаковки,
	               |	АптекаОфис.КодАптеки КАК КодАптеки,
	               |	АптекаОфис.ИдентификаторДокумента КАК ИДДокумента,
	               |	Аптеки.Ссылка КАК Склад,
	               |	Аптеки.Ссылка.Фирма КАК Фирма,
	               |	АптекаОфис.ДатаДокумента
	               |ИЗ
	               |	РегистрСведений.АптекаОфисОперКасса КАК АптекаОфис
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.МестаХранения КАК Аптеки
	               |		ПО (Аптеки.Код = АптекаОфис.КодАптеки)
	               |ГДЕ
	               |	АптекаОфис.ТипУпаковки = ""OPER_CASH""
	               |	И 111 = 111
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	КодАптеки,
	               |	Код";
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция РазобратьУпаковку(стр,Упаковка)
	
	Результат = Новый Структура;
	Результат.Вставить("Результат",Ложь);
	
	ХМЛ = Новый ЧтениеXML();
	Попытка
		ХМЛ.УстановитьСтроку(Упаковка);
	Исключение
		Возврат Результат;
	КонецПопытки;
	
		//<?xml version="1.0" encoding="WINDOWS-1251"?>
		//<document>
		//<pack_type>OPER_CASH</pack_type>
		//<fmt_ver>1</fmt_ver>
		
		//<hdr>
		//<id>794</id>
		//<id_doc_type>302</id_doc_type>
		//<guid>157abe62-a8ba-11e5-baa2-78e3b5fcba08</guid>
		//<ndoc>14</ndoc>
		//<ddoc>20151222174111</ddoc>
		//<status>3</status>
		//<id_acc>2</id_acc>
		//<operation>-1</operation>
		//<sum_order>33300.00</sum_order>
		//<id_session_hdr/>
		//<id_cash_collection_hdr>793</id_cash_collection_hdr>
		//<id_buyer_return_hdr/>
		//<id_prepay/>
		//<id_worker/>
		//<worker_tabnum/>
		//<id_bank>44585659</id_bank>
		//<num_sheet/>
		//<date_sheet/>
		//<appendix>Препроводительная ведомость №23895&#x2F;670 от 22.12.2015</appendix>
		//<dsc>Сданы денежные средства в банк</dsc>
		//<identification_doc/>
		//<rec_insert>20151222174128</rec_insert>
		//<rec_update>20160112112916</rec_update>
		//<login_key>admin</login_key>
		//<user_descr/>
		//<ver>3</ver>
		//<cash_amount_rest>1111.50</cash_amount_rest> - остаток наличности после инкассации.
		//</hdr>
		
		//<str/>
		
		//</document>
		//
		
		
		Шапка = Новый Структура();		
		
			
		Пока ХМЛ.Прочитать() Цикл
			Если ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента И ХМЛ.Имя="hdr" ТОгда
				Пока ХМЛ.Прочитать() Цикл
					Если ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="guid" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Шапка.Вставить("ИДДокументаАптеки",ХМЛ.Значение);
						КонецЕсли;
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="ndoc" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Шапка.Вставить("НомДокАптеки", ХМЛ.Значение );
						КонецЕсли;		
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="num_sheet" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Шапка.Вставить("НомерВедомости", СокрЛП(Формат(ХМЛ.Значение,"ЧГ=0")));
						КонецЕсли;		
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="date_sheet" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Шапка.Вставить("ДатаВедомости", Дата(ХМЛ.Значение));
						КонецЕсли;	
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="session" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Шапка.Вставить("IDСессии", СокрЛП(ХМЛ.Значение));
						КонецЕсли;	
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="receipt_no" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Шапка.Вставить("НомерКвитанции", СокрЛП(ХМЛ.Значение));
						КонецЕсли;						
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="ddoc" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Шапка.Вставить("ДатаДок", Дата(ХМЛ.Значение));
						КонецЕсли;		
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="id_acc" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Шапка.Вставить("Счет", Справочники.Счета.НайтиПоКоду(Число(ХМЛ.Значение))); 
							Шапка.Вставить("КодСчета", Число(ХМЛ.Значение));
						КонецЕсли;
						
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="id_bank" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Шапка.Вставить("КодБанка", СокрЛП(Формат(ХМЛ.Значение,"ЧГ=0"))); //Разбираем , но пока не используем
						КонецЕсли;	
						
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="sum_order" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Если ПустаяСтрока(ХМЛ.Значение)=Ложь ТОгда
								Шапка.Вставить("Сумма", Число(ХМЛ.Значение));
							КонецЕсли;
						КонецЕсли;
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="cash_amount_rest" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Если ПустаяСтрока(ХМЛ.Значение)=Ложь ТОгда
								Шапка.Вставить("СуммаПослеИнкассации", Число(ХМЛ.Значение));
							КонецЕсли;
						КонецЕсли;						
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="appendix" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Если ПустаяСтрока(ХМЛ.Значение)=Ложь ТОгда
								Шапка.Вставить("Приложение", СокрЛП(ХМЛ.Значение));
							КонецЕсли;
						КонецЕсли;
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="dsc" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Если ПустаяСтрока(ХМЛ.Значение)=Ложь ТОгда
								Шапка.Вставить("Описание", СокрЛП(ХМЛ.Значение));
							КонецЕсли;
						КонецЕсли;
						
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="identification_doc" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Если ПустаяСтрока(ХМЛ.Значение)=Ложь ТОгда
								Шапка.Вставить("Паспорт", СокрЛП(ХМЛ.Значение));   //Разбираем , но пока не используем
							КонецЕсли;
						КонецЕсли;
						
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="status" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Если ПустаяСтрока(ХМЛ.Значение)=Ложь ТОгда
								Шапка.Вставить("СтатусДокАптеки",Число(ХМЛ.Значение));
							КонецЕсли;
						КонецЕсли;
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="operation" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Если ПустаяСтрока(ХМЛ.Значение)=Ложь ТОгда
								Шапка.Вставить("КодВидаОперации",Число(ХМЛ.Значение));
							КонецЕсли;
						КонецЕсли;
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.НачалоЭлемента и ХМЛ.Имя="user_descr" Тогда
						ХМЛ.Прочитать();
						Если ХМЛ.ИмеетЗначение Тогда
							Если ПустаяСтрока(ХМЛ.Значение)=Ложь ТОгда
								Шапка.Вставить("СотрудникАптеки", СокрЛП(ХМЛ.Значение));
							КонецЕсли;
						КонецЕсли;
						
						
						
					ИначеЕсли ХМЛ.ТипУзла=ТипУзлаXML.КонецЭлемента и ХМЛ.Имя="hdr" Тогда  // это конец шапки	
						
						Прервать; // Закончили обрабатывать шапку , нужно выйти в верхний цикл.
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
		ХМЛ.Закрыть();
		
		Результат.Вставить("Шапка",Шапка);
		Результат.Результат = Истина;
		
		Возврат Результат;
		
	
	
	КонецФункции
	
Процедура СоздатьКассовыйОрдер(стр,СтруктураРезультата)
	
	Шапка = СтруктураРезультата.Шапка;
	
	Если Шапка.КодСчета = 7 или  Шапка.КодСчета = 11 или Шапка.КодСчета = 13 или Шапка.ДатаДок < Дата(2017,08,18) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;                                                    
	Запрос.Текст = "ВЫБРАТЬ
	               |	Ордер.Ссылка
	               |ИЗ
	               |	Документ.КассовыйОрдер КАК Ордер
	               |ГДЕ
	               |	Ордер.ИДДокументаАптеки = &ИДДокументаАптеки
	               |	И Ордер.Склад = &Склад";
	
	Запрос.УстановитьПараметр("ИДДокументаАптеки",Шапка.ИДДокументаАптеки);
	Запрос.УстановитьПараметр("Склад",стр.Склад);
	
	Рез = Запрос.Выполнить();
	ЭтоНовыйДокумент = Ложь;
	ДокОбъект = Неопределено;
	Если Рез.Пустой() Тогда
		Док = Документы.КассовыйОрдер.СоздатьДокумент();
		
		ЭтоНовыйДокумент = Истина;
	Иначе
		Выборка = Рез.Выбрать();
		Выборка.Следующий();
		Док = Выборка.Ссылка.ПолучитьОбъект();
	КонецЕсли;
	пер_Статус = Перечисления.СтатусДокАптеки.Получить(Шапка.СтатусДокАптеки);
	
	ЗаполнитьЗначенияСвойств(Док,Шапка);
	
	Док.Дата = Шапка.ДатаДок;
	Док.СтатусДокАптеки = пер_Статус;
	Если Шапка.КодВидаОперации = - 1 Тогда
		Док.ВидОперации = Перечисления.ВидыОпераций.РасходныйОрдер;
	ИначеЕсли Шапка.КодВидыОперации = 1 Тогда
		Док.ВидОперации = Перечисления.ВидыОпераций.ПриходныйОрдер;
	КонецЕсли;
	Док.Склад = стр.Склад;
	Док.Фирма = стр.Фирма;
	
	Если Док.СтатусДокАптеки = Перечисления.СтатусДокАптеки.Проведен Тогда
		Док.Записать(РежимЗаписиДокумента.Проведение);
	ИначеЕсли Док.СтатусДокАптеки = Перечисления.СтатусДокАптеки.Создан Тогда
		Если Док.Проведен = Истина Тогда
			Док.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Иначе
			Док.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
	ИначеЕсли Док.СтатусДокАптеки = Перечисления.СтатусДокАптеки.Аннулирован Тогда
		Если Док.Проведен = Истина Тогда
			Док.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Иначе
			Док.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
	КонецЕсли;
	
	
	
	
КонецПроцедуры

Процедура УдалитьУпаковку(КодУпаковки)
	
			НЗ=РегистрыСведений.АптекаОфисОперКасса.СоздатьНаборЗаписей();
			НЗ.Отбор.Код.Установить(КодУпаковки,Истина);
			НЗ.Записать();	
	
КонецПроцедуры

Процедура ЗагрузитьОперационнуюКассу() Экспорт
	
	Упаковки = ПолучитьУпаковкиОперКассы();	
	
	н=0;
	Всего = Упаковки.Количество();
	Для каждого стр из Упаковки Цикл
		н=н+1;
		#Если Клиент Тогда
			ОбработкаПрерыванияПользователя();
			Если н%100 = 0 Тогда
				Состояние("обработка: " + н + " из " + Всего);
			КонецЕсли;
		#КонецЕсли
	
		МЗ = РегистрыСведений.АптекаОфисОперКасса.СоздатьМенеджерЗаписи();
		МЗ.Код = стр.Код;
		МЗ.Прочитать();
		
		Если НЕ МЗ.Выбран() Тогда
			Продолжить;
		КонецЕсли;
		
		Упаковка = МЗ.ХМЛСтрока; 
		СтруктураРезультата = РазобратьУпаковку(стр, Упаковка);	
		Если СтруктураРезультата.Результат = Истина Тогда
			СоздатьКассовыйОрдер(стр,СтруктураРезультата);	
			УдалитьУпаковку(стр.Код);
		КонецЕсли;
		
		
			
	КонецЦикла;
	
	
КонецПроцедуры
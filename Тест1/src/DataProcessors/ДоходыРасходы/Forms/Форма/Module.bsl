
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьИнфо();
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнфо()
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	             |	Машины.Ссылка,
				 |  Машины.Наименование
	             |ИЗ
	             |	Справочник.Машины КАК Машины" ;
	маш = Запрос.Выполнить().Выгрузить();
	Запрос.Текст =  "ВЫБРАТЬ
	                |	ПродажаЗапчастей.Ссылка,
	                |	ПродажаЗапчастей.ВерсияДанных,
	                |	ПродажаЗапчастей.ПометкаУдаления,
	                |	ПродажаЗапчастей.Номер,
	                |	ПродажаЗапчастей.Дата,
	                |	ПродажаЗапчастей.Проведен,
	                |	ПродажаЗапчастей.Клиент,
	                |	ПродажаЗапчастей.Комментарий,
	                |	ПродажаЗапчастей.Доставка,
	                |	ПродажаЗапчастей.Расход,
	                |	ПродажаЗапчастей.СрокПроверки,
	                |	ПродажаЗапчастей.Организация,
	                |	ПродажаЗапчастей.ИтогоРекв,
	                |	ПродажаЗапчастей.КтоПродал,
	                |	ПродажаЗапчастей.Оплачено,
	                |	ПродажаЗапчастей.УжеОплачено,
	                |	ПродажаЗапчастей.Откат,
	                |	ПродажаЗапчастей.КомуОткат,
	                |	ПродажаЗапчастей.ОтданоМарату,
	                |	ПродажаЗапчастей.ИтогоБезнал,
	                |	ПродажаЗапчастей.АртикулВНазвании,
	                |	ПродажаЗапчастей.ВычитатьИзСуммы,
	                |	ПродажаЗапчастей.ПотеряНаОбналичку,
	                |	ПродажаЗапчастей.Таблица.(
	                |		Ссылка,
	                |		НомерСтроки,
	                |		Товар,
	                |		Количество,
	                |		Цена,
	                |		Скидка,
	                |		машина,
	                |		цена1,
	                |		Комментарий,
	                |		Сумма
	                |	),
	                |	ПродажаЗапчастей.Представление,
	                |	ПродажаЗапчастей.МоментВремени
	                |ИЗ
	                |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	                |ГДЕ
	                |	ПродажаЗапчастей.Проведен = ИСТИНА" ;
	продажи = Запрос.Выполнить().Выгрузить();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВыводДенегИзРазборки.Ссылка,
	               |	ВыводДенегИзРазборки.ВерсияДанных,
	               |	ВыводДенегИзРазборки.ПометкаУдаления,
	               |	ВыводДенегИзРазборки.Номер,
	               |	ВыводДенегИзРазборки.Дата,
	               |	ВыводДенегИзРазборки.Проведен,
	               |	ВыводДенегИзРазборки.Машина,
	               |	ВыводДенегИзРазборки.Кому,
	               |	ВыводДенегИзРазборки.Сумма,
	               |	ВыводДенегИзРазборки.Нам,
	               |	ВыводДенегИзРазборки.Марату,
	               |	ВыводДенегИзРазборки.ИтогоОткатов,
	               |	ВыводДенегИзРазборки.Таблица.(
	               |		Ссылка,
	               |		НомерСтроки,
	               |		Документ,
	               |		нам,
	               |		марату,
	               |		Расходы,
	               |		итогсум
	               |	)
	               |ИЗ
	               |	Документ.ВыводДенегИзРазборки КАК ВыводДенегИзРазборки";
	выводы = Запрос.Выполнить().Выгрузить();
	ИтогиВсего =0;
	ИтогиНам=0;
	ИтогиМарату = 0;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Партии.Ссылка,
	               |	Партии.ВерсияДанных,
	               |	Партии.ПометкаУдаления,
	               |	Партии.Предопределенный,
	               |	Партии.Код,
	               |	Партии.Наименование,
	               |	Партии.Таблица.(
	               |		Ссылка,
	               |		НомерСтроки,
	               |		Машина
	               |	)
	               |ИЗ
	               |	Справочник.Партии КАК Партии";
	партии1 = Запрос.Выполнить().Выгрузить();
	Для Каждого партия3 Из партии1 Цикл
		пвсего = 0;
		пвложено = 0;
		пнам = 0;
		пмарату = 0;
		Для Каждого пм Из партия3.Таблица Цикл
			груз = пм.Машина;
			Всего = 0;
			машин = груз.Ссылка;
			пвложено = пвложено + груз.Сумма;
			Для Каждого прод Из продажи Цикл
				итого = прод.ИтогоРекв;
				расходы = прод.Откат;
				Для Каждого зап Из прод.Таблица Цикл
					Если зап.машина = машин Тогда
						всг = зап.Количество*зап.Цена - зап.Скидка;
						Если расходы > 0 Тогда
							всг = всг - расходы*(всг/итого);
						КонецЕсли;					
						Всего = Всего + всг;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			ИтогоНам = 0;
			ИтогоМарату = 0;
			Для Каждого вывод Из выводы Цикл
				Для Каждого док Из вывод.Таблица Цикл
					итого = док.Документ.ИтогоРекв - док.Документ.Расход;
					марату = док.марату;
					нам = док.нам;
					Для Каждого зап Из док.Документ.Таблица Цикл
						расходы = прод.Откат;
						Если зап.машина = машин И док.Документ.Проведен = ИСТИНА И док.Документ.ОтданоМарату = ИСТИНА Тогда
							всг = зап.Количество*зап.Цена - зап.Скидка;
							Если расходы > 0 Тогда
								всг = всг - расходы*(всг/итого);
							КонецЕсли;
							ИтогоНам = ИтогоНам + всг*нам/итого;
						ИтогоМарату = ИтогоМарату + всг*марату/итого;
						КонецЕсли;
						
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
			
			стр = машины.Добавить();
			стр.машина = груз.Ссылка;
			стр.всего = Всего;
			стр.марату = ИтогоМарату;
			стр.нам = ИтогоНам;
			ИтогиВсего =ИтогиВсего + Всего;
			пвсего = пвсего + Всего;
			
			пнам = пнам + ИтогоНам;
			пмарату = пмарату + ИтогоМарату;
		ИтогиНам=ИтогиНам+ИтогоНам;
		ИтогиМарату = ИтогиМарату+ИтогоМарату;
	КонецЦикла;
	стр2 = Партии.Добавить();
	стр2.Всего = пвсего;
	стр2.Вложено = пвложено;
	стр2.Нам = пнам;
	стр2.Марату = пмарату;
	КонецЦикла;

КонецПроцедуры


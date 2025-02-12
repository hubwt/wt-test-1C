
&НаКлиенте
Перем ПредупреждениеОСуществованииДокумента;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Объект.Дата = ТекущаяДата();
		Объект.ОткрытСуществующийДокумент = Ложь;
		Объект.Процент = 1;
		Заполнить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьСуществованиеДокумента();
	
КонецПроцедуры
	
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если НачалоМесяца(Объект.Дата) = НачалоМесяца(ТекущаяДата()) Тогда
		Объект.Дата = ТекущаяДата();
	Иначе
		Объект.Дата = КонецМесяца(Объект.Дата);
	КонецЕсли;
	Объект.ОткрытСуществующийДокумент = Ложь;
	ПроверитьСуществованиеДокумента();
	
	Заполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура Пересчитать(Команда)
	Заполнить();
КонецПроцедуры

&НаКлиенте
Процедура ПроцентПриИзменении(Элемент)
	ПосчитатьПроцент();
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСуществованиеДокумента()
	
	НомерСуществующегоДок = ПолучитьНомерДокТекущегоМес(); 
	Если НомерСуществующегоДок <> 0 И НомерСуществующегоДок <> НомерДокументаНаСервере() Тогда
		
		ОчиститьСообщения();
		Сообщить(ПредупреждениеОСуществованииДокумента);
	ИначеЕсли (НомерСуществующегоДок = НомерДокументаНаСервере()) И
				(НачалоМесяца(Объект.Дата) = НачалоМесяца(ТекущаяДата())) Тогда
				
		ПоказатьВопрос(Новый ОписаниеОповещения("ОкончаниеВопроса", ЭтотОбъект),
                          "Обновить на текущую дату?", РежимДиалогаВопрос.ДаНет);
		
	Иначе
		УстановитьОткрытСуществующийДокументНаСервере();		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеВопроса(РезультатВопроса, ПараметрыЗаписи) Экспорт
        
 	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
    	ОбновитьДокументНаТекущуюДату();
		УстановитьОткрытСуществующийДокументНаСервере();
 	КонецЕсли;
        
КонецПроцедуры

&НаСервере
Процедура УстановитьОткрытСуществующийДокументНаСервере()
	Объект.ОткрытСуществующийДокумент = Истина;	
КонецПроцедуры

&НаСервере
Функция ПолучитьОткрытСуществующийДокументНаСервере()
	Возврат Объект.ОткрытСуществующийДокумент;	
КонецФункции


&НаСервере
Процедура ОбновитьДокументНаТекущуюДату()
	Заполнить();
	Объект.Дата = ТекущаяДата();
КонецПроцедуры

&НаСервере
Функция НомерДокументаНаСервере()
	Возврат Объект.Номер;	
КонецФункции

&НаСервере
Процедура Заполнить()
	
	Объект.ПродажиПремии.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Объект.Дата));
	Запрос.Текст = "ВЫБРАТЬ
		|   Документ.КтоПродал КАК Сотрудник,
		|   СУММА(Сумма) КАК СуммаПродаж
		|
		|ИЗ
		|	РегистрНакопления.ОплатыПоСделкам
		|
		|ГДЕ
		|	Период МЕЖДУ &НачалоПериода И &КонецПериода
		|   И Документ ССЫЛКА Документ.ПродажаЗапчастей
		|
		|СГРУППИРОВАТЬ ПО
		|	Документ.КтоПродал
		|
		|";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	ТЗ.Сортировать("Сотрудник");

	Объект.ПродажиВсего = ТЗ.Итог("СуммаПродаж");
	
	Объект.ПродажиПремии.Загрузить(ТЗ);
	
	ПосчитатьПроцент();
	
КонецПроцедуры

&НаСервере
Процедура ПосчитатьПроцент()
	
	Объект.ПремияОбщая = (Объект.ПродажиВсего * Объект.Процент) / 100;
	
	Для Каждого стр ИЗ Объект.ПродажиПремии Цикл
		ПроцентВклада = стр.СуммаПродаж / Объект.ПродажиВсего;
		стр.ПроцентВклада = ПроцентВклада * 100;
		стр.Премия = ПроцентВклада * Объект.ПремияОбщая; 		
	КонецЦикла;
	
КонецПроцедуры



&НаСервере
Функция ПолучитьНомерДокТекущегоМес()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Объект.Дата));
	Запрос.Текст = "ВЫБРАТЬ
		|   Номер
		|
		|ИЗ
		|	Документ.ПремииМенеджерамПоПродажам
		|
		|ГДЕ
		|	Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|";
	
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Количество() = 0 Тогда
		Возврат 0;
	Иначе
		Выборка.Следующий();
		Возврат Выборка.Номер;                                      
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ ПолучитьОткрытСуществующийДокументНаСервере() Тогда
		
		ОчиститьСообщения();
		Сообщить(ПредупреждениеОСуществованииДокумента);
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

ПредупреждениеОСуществованииДокумента = "В этом месяце уже создан документ.
					| Введите другую дату
					| или войдите в созданный
					| документ.";	



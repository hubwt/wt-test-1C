
&НаКлиенте
Процедура Список1Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОповеститьОВыборе(ВыбраннаяСтрока) ;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НовыеЗП = Истина Тогда
		//ЭтаФорма.Элементы.Группа2.Видимость = Ложь;
		ЭтаФорма.Элементы.Группа1.ТекущаяСтраница = ЭтаФорма.Элементы.Группа3;
		Всего = УстСтроку(1);
		Если Всего > 0 Тогда
			ЭтаФорма.ТекущийЭлемент = Элементы.Список1;
			Элементы.Список1.АктивизироватьПоУмолчанию=Истина;
			Элементы.Список1.ТекущаяСтрока = Всего -1;
		КонецЕсли;    
	Иначе
		ЭтаФорма.Элементы.Группа3.Видимость = Ложь;
		Всего = УстСтроку(0);
		Если Всего > 0 Тогда
			Элементы.Список.ТекущаяСтрока = Всего -1;
		КонецЕсли; 
    КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДок(Команда)
	
		
	// Вставить содержимое обработчика.
	ФормаСписка = ПолучитьФорму("Документ.ПредварительныйСчет.ФормаОбъекта");
	ФормаСписка.ВладелецФормы = ЭтаФорма;
	Если ЭтаФорма.Элементы.Группа1.ТекущаяСтраница = ЭтаФорма.Элементы.Группа3 Тогда
		ФормаСписка.Объект.Новые=Истина;
	КонецЕсли;
	Если Не ФормаСписка.Открыта() Тогда
    	ФормаСписка.ОткрытьМодально();
	КонецЕсли;  
КонецПроцедуры

&НаСервере
Функция УстСтроку(тип)
	запрос = Новый Запрос;
	з = "ЛОЖЬ";
	Если тип = 1 Тогда
		з="ИСТИНА";
	КонецЕсли;
	запрос.Текст = "ВЫБРАТЬ
		               |	ПродажаЗапчастей.Ссылка
		               |ИЗ
		               |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
		               |ГДЕ
		               |	ПродажаЗапчастей.Новые = "+з;
	 Возврат запрос.Выполнить().Выгрузить().Количество();	  
КонецФункции

&НаКлиенте
Процедура Поиск(Команда)
	// Вставить содержимое обработчика.
	ПоискСерв();
КонецПроцедуры

&НаСервере
Процедура ПоискСерв()
	Пск = РазбитьСтрокуНаМассивПодстрок(строкаПоиска," "); 
	ТекстЗапроса = "ВЫБРАТЬ
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
	                      |	ПродажаЗапчастей.ОстатокДенег,
	                      |	ПродажаЗапчастей.ВозвратТовара,
	                      |	ПродажаЗапчастей.СуммаВозврат,
	                      |	ПродажаЗапчастей.ТранспортнаяКомпания,
	                      |	ПродажаЗапчастей.Вес,
	                      |	ПродажаЗапчастей.Объем,
	                      |	ПродажаЗапчастей.КоличествоМест,
	                      |	ПродажаЗапчастей.ГородОтправки,
	                      |	ПродажаЗапчастей.РегионПолучения,
	                      |	ПродажаЗапчастей.ГородПолучения,
	                      |	ПродажаЗапчастей.СтоимостьДоставки,
	                      |	ПродажаЗапчастей.ЕстьДоставка,
	                      |	ПродажаЗапчастей.ДоставкаНеЗаполнена,
	                      |	ПродажаЗапчастей.Самовывоз,
	                      |	ПродажаЗапчастей.СтранаПолучения,
	                      |	ПродажаЗапчастей.Новые,
	                      |	ПродажаЗапчастей.Скидка,
	                      |	ПродажаЗапчастей.КоммДост,
	                      |	ПродажаЗапчастей.НомерПП,
	                      |	ПродажаЗапчастей.TipOplati,
	                      |	ПродажаЗапчастей.доставкаКлиент,
	                      |	ПродажаЗапчастей.частный,
	                      |	ПродажаЗапчастей.НаименованиеИлиФИО,
	                      |	ПродажаЗапчастей.ИНН,
	                      |	ПродажаЗапчастей.Телефон,
	                      |	ПродажаЗапчастей.Паспорт,
	                      |	ПродажаЗапчастей.Прописка,
	                      |	ПродажаЗапчастей.СтатусДоставки
	                      |ИЗ
	                      |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	                      |ГДЕ
	                      |	ПродажаЗапчастей.Новые = ЛОЖЬ";	
	Если Не ТипОплаты.Пустая() Тогда
		ТекстЗапроса = ТекстЗапроса + " И ПродажаЗапчастей.TipOplati = &типоплаты ";
	КонецЕсли;
	ном = 1;
	Для Каждого элем из Пск Цикл
		Если ном = 1 Тогда
			ТекстЗапроса = ТекстЗапроса + " И ( ПродажаЗапчастей.Номер ПОДОБНО ""%"+элем+""" ИЛИ ПродажаЗапчастей.Клиент.Наименование ПОДОБНО ""%"+элем+"%"""+ " ИЛИ ПродажаЗапчастей.Клиент.ФИО ПОДОБНО ""%"+элем+"%""" + " ИЛИ ПродажаЗапчастей.Клиент.Телефон ПОДОБНО ""%"+элем+"%""";
		Иначе
			ТекстЗапроса = ТекстЗапроса + " ИЛИ ПродажаЗапчастей.Номер ПОДОБНО ""%"+элем+""" ИЛИ ПродажаЗапчастей.Клиент.Наименование ПОДОБНО ""%"+элем+"%"""+ " ИЛИ ПродажаЗапчастей.Клиент.ФИО ПОДОБНО ""%"+элем+"%""" + " ИЛИ ПродажаЗапчастей.Клиент.Телефон ПОДОБНО ""%"+элем+"%""";
		КонецЕсли;
		ном = 2;
	КонецЦикла;
	Если Пск.Количество() > 0 Тогда
		ТекстЗапроса = ТекстЗапроса + " ) ";
	КонецЕсли;
	Список.ТекстЗапроса = ТекстЗапроса;
	Если Не ТипОплаты.Пустая() Тогда
		список.Параметры.УстановитьЗначениеПараметра("типоплаты",ТипОплаты);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура Очистить(Команда)
	ОчиститьСерв();
КонецПроцедуры

&НаСервере
Процедура ОчиститьСерв()
	Список.ТекстЗапроса = "ВЫБРАТЬ
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
	                      |	ПродажаЗапчастей.ОстатокДенег,
	                      |	ПродажаЗапчастей.ВозвратТовара,
	                      |	ПродажаЗапчастей.СуммаВозврат,
	                      |	ПродажаЗапчастей.ТранспортнаяКомпания,
	                      |	ПродажаЗапчастей.Вес,
	                      |	ПродажаЗапчастей.Объем,
	                      |	ПродажаЗапчастей.КоличествоМест,
	                      |	ПродажаЗапчастей.ГородОтправки,
	                      |	ПродажаЗапчастей.РегионПолучения,
	                      |	ПродажаЗапчастей.ГородПолучения,
	                      |	ПродажаЗапчастей.СтоимостьДоставки,
	                      |	ПродажаЗапчастей.ЕстьДоставка,
	                      |	ПродажаЗапчастей.ДоставкаНеЗаполнена,
	                      |	ПродажаЗапчастей.Самовывоз,
	                      |	ПродажаЗапчастей.СтранаПолучения,
	                      |	ПродажаЗапчастей.Новые,
	                      |	ПродажаЗапчастей.Скидка,
	                      |	ПродажаЗапчастей.КоммДост,
	                      |	ПродажаЗапчастей.НомерПП,
	                      |	ПродажаЗапчастей.TipOplati,
	                      |	ПродажаЗапчастей.доставкаКлиент,
	                      |	ПродажаЗапчастей.частный,
	                      |	ПродажаЗапчастей.НаименованиеИлиФИО,
	                      |	ПродажаЗапчастей.ИНН,
	                      |	ПродажаЗапчастей.Телефон,
	                      |	ПродажаЗапчастей.Паспорт,
	                      |	ПродажаЗапчастей.Прописка,
	                      |	ПродажаЗапчастей.СтатусДоставки
	                      |ИЗ
	                      |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	                      |ГДЕ
	                      |	ПродажаЗапчастей.Новые = ЛОЖЬ";
КонецПроцедуры
					  
&НаСервере
Функция РазбитьСтрокуНаМассивПодстрок(ИсходнаяСтрока,РазделительСтрок)
   СтрокаДляРазбора = ИсходнаяСтрока;
   МассивСтрок = новый Массив;
   СтрокаДляРазбора1 = СокрЛП(СтрокаДляРазбора);
   Если СтрДлина(СтрокаДляРазбора1) < 2 Тогда
	   Возврат МассивСтрок;
   КонецЕсли;
   СтрокаДляРазбора = СтрЗаменить(СтрокаДляРазбора, РазделительСтрок, Символы.ПС);      
   КолвоСтрок = СтрЧислоСтрок(СтрокаДляРазбора);
   Для НомСтр = 1 По КолвоСтрок Цикл
      МассивСтрок.Добавить(СтрПолучитьСтроку(СтрокаДляРазбора, НомСтр));
  КонецЦикла;
  Возврат МассивСтрок;
КонецФункции




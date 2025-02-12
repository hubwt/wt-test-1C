
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура СписокТМЦКоличествоПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("СписокТМЦ", "Цена");
КонецПроцедуры


&НаКлиенте
Процедура СписокТМЦЦенаПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("СписокТМЦ", "Цена");
КонецПроцедуры


&НаКлиенте
Процедура СписокТМЦИнвентарныйНомерПриИзменении(Элемент)
	
	//ТекСтрока = Элементы.СписокТМЦ.ТекущиеДанные;
	//
	//РаботаСДокументамиТМЦКлиент.УстановитьДанныеПоИнвентарномуНомеру(ТекСтрока);
	//
	//ОбработкаИзмененияСтроки("СписокТМЦ", "Цена");
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПечатьАктПеремещения(Команда)
	
	///+ГомзМА 14.04.2023 
	ТабДок = ПечатьАктСписанияНаСервере();
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("АктПеремещения");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров=1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "АктПеремещения";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм,Неопределено,ЭтаФорма);
	///-ГомзМА 14.04.2023
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаКлиенте
Процедура ОбработкаИзмененияСтроки(ИмяТабличнойЧасти, Поле = Неопределено, ДанныеСтроки = Неопределено)
	
	ТекДанные = ?(ДанныеСтроки = Неопределено, Элементы[ИмяТабличнойЧасти].ТекущиеДанные, ДанныеСтроки);
	
	Если Поле = "Сумма" Тогда
		Если ТекДанные.Количество <> 0 Тогда
			ТекДанные.Цена = ТекДанные.Сумма / ТекДанные.Количество;
		КонецЕсли;	
	Иначе	
		ТекДанные.Сумма = ТекДанные.Цена * ТекДанные.Количество;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаИзмененияСтроки()


&НаСервере
Функция ПечатьАктСписанияНаСервере()
	
	///+ГомзМА 02.05.2023 
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.ПеремещениеТМЦВорктрак.ПолучитьМакет("АктПеремещения");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПеремещениеТМЦВорктракСписокТМЦ.НомерСтроки КАК НомерСтроки,
	|	ПеремещениеТМЦВорктракСписокТМЦ.ТМЦ КАК ТМЦ,
	|	ПеремещениеТМЦВорктракСписокТМЦ.Количество КАК Количество,
	|	ПеремещениеТМЦВорктракСписокТМЦ.Цена КАК Цена,
	|	ПеремещениеТМЦВорктракСписокТМЦ.Сумма КАК Сумма,
	|	ПеремещениеТМЦВорктракСписокТМЦ.Склад КАК Склад,
	|	ПеремещениеТМЦВорктракСписокТМЦ.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	ПеремещениеТМЦВорктракСписокТМЦ.СерийныйНомер КАК СерийныйНомер,
	|	ПеремещениеТМЦВорктракСписокТМЦ.Ссылка.Ссылка КАК Ссылка,
	|	ПеремещениеТМЦВорктракСписокТМЦ.Ссылка.Ответственный КАК Ответственный,
	|	ПеремещениеТМЦВорктракСписокТМЦ.Ссылка.Номер КАК Номер,
	|	ПеремещениеТМЦВорктракСписокТМЦ.Ссылка.Дата КАК Дата,
	|	ПеремещениеТМЦВорктракСписокТМЦ.Ссылка.Комментарий КАК Комментарий,
	|	ПеремещениеТМЦВорктракСписокТМЦ.ТМЦ.Код КАК ТМЦКод
	|ИЗ
	|	Документ.ПеремещениеТМЦВорктрак.СписокТМЦ КАК ПеремещениеТМЦВорктракСписокТМЦ
	|ГДЕ
	|	ПеремещениеТМЦВорктракСписокТМЦ.Ссылка.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ВыборкаЗапрос = Запрос.Выполнить().Выбрать();
		
	ОбластьШапка  = Макет.ПолучитьОбласть("ОбластьШапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("ОбластьСтрока");
	ОбластьПодвал = Макет.ПолучитьОбласть("ОбластьПодвал");
	ТабДок.Очистить();
	
	ВыборкаЗапрос.Следующий();
	
	ОбластьШапка.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьШапка, ВыборкаЗапрос.Уровень());
	
	ОбластьСтрока.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьСтрока, ВыборкаЗапрос.Уровень());
		
	Пока ВыборкаЗапрос.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(ВыборкаЗапрос);
		ТабДок.Вывести(ОбластьСтрока, ВыборкаЗапрос.Уровень());
	КонецЦикла;
	
	ТабДок.Вывести(ОбластьПодвал);
	
	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	
	Возврат ТабДок;
	///-ГомзМА 02.05.2023
КонецФункции

&НаКлиенте
Процедура СписокТМЦИнвентарныйНомерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	///+ГомзМА 19.05.2023
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = Элементы.СписокТМЦ.ТекущиеДанные;
	
	ОткрытьФорму("Справочник.ИнвентарныеНомера.ФормаВыбора",, ЭтаФорма,ЭтаФорма.УникальныйИдентификатор);
	///-ГомзМА 19.05.2023
	
КонецПроцедуры


&НаСервере
Процедура ПриЗакрытииФормыВыбора(Значение, ДопПараметры) Экспорт
	
	ДобавлениеИнвентарногоНомера(Значение, ДопПараметры);
	
КонецПроцедуры


&НаСервере
Процедура ДобавлениеИнвентарногоНомера(ДанныеЗаполнения, ИнвентарныйНомер)
	
	ИнвентарныйНомер = ДанныеЗаполнения.Ссылка;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Перем Команда;
	
	ТекСтрока = Элементы.СписокТМЦ.ТекущиеДанные;
	ВыбранноеЗначение.Свойство("Команда", Команда);
	Если Команда = "ПравильныйПоиск" Тогда
		ТекСтрока.ИнвентарныйНомер = ВыбранноеЗначение.Ссылка;
	КонецЕсли;
	
	ТекСтрока = Элементы.СписокТМЦ.ТекущиеДанные;
	
	РаботаСДокументамиТМЦКлиент.УстановитьДанныеПоИнвентарномуНомеру(ТекСтрока);
	
	ОбработкаИзмененияСтроки("СписокТМЦ", "Цена");
		
КонецПроцедуры

#КонецОбласти

















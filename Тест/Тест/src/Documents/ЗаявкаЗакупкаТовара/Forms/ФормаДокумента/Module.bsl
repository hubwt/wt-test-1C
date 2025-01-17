
&НаСервереБезКонтекста
Функция ПолучитьДанныеТовара(СсылкаНаТовар)
/// Комлев АА 22/11/24 +++
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Код КАК Код,
	|	Номенклатура.Артикул КАК Артикул,
	|	Номенклатура.Производитель КАК Производитель,
	|	Номенклатура.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТ_ДанныеОТоваре
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &СсылкаНаТовар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВТ_ДанныеОТоваре.Код КАК Код,
	|	ВТ_ДанныеОТоваре.Артикул КАК Артикул,
	|	ВТ_ДанныеОТоваре.Производитель КАК Производитель,
	|	дт_ЦеныНоменклатурыСрезПоследних.Цена КАК ЦенаПродажи,
	|	ВТ_ДанныеОТоваре.Ссылка КАК Ссылка
	|ИЗ
	|	ВТ_ДанныеОТоваре КАК ВТ_ДанныеОТоваре
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.дт_ЦеныНоменклатуры.СрезПоследних(, Номенклатура В
	|			(ВЫБРАТЬ
	|				ДанныеОТоваре.Ссылка
	|			ИЗ
	|				ВТ_ДанныеОТоваре КАК ДанныеОТоваре)) КАК дт_ЦеныНоменклатурыСрезПоследних
	|		ПО (дт_ЦеныНоменклатурыСрезПоследних.Номенклатура = ВТ_ДанныеОТоваре.Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	дт_ЦеныНоменклатурыСрезПоследних.Период УБЫВ";

	Запрос.УстановитьПараметр("СсылкаНаТовар", СсылкаНаТовар);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();
	СтруктураТовара  = Новый Структура;
	Пока Выборка.Следующий() Цикл
		СтруктураТовара.Вставить("Код", Выборка.Код);
		СтруктураТовара.Вставить("Артикул", Выборка.Артикул);
		СтруктураТовара.Вставить("Производитель", Выборка.Производитель);
		СтруктураТовара.Вставить("ЦенаПродажи", Выборка.ЦенаПродажи);
	КонецЦикла;
	Возврат СтруктураТовара;
	/// Комлев АА 22/11/24 ---
КонецФункции
&НаКлиенте
Процедура ЗакупленныйТоварКоличествоПриИзменении(Элемент)
	ТекДанные = Элементы.ЗакупленныйТовар.ТекущиеДанные;
	ТекДанные.СуммаЗакупки = ТекДанные.СуммаЗакупки * ТекДанные.Количество;
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекДанные.СуммаНДС = ТекДанные.СуммаЗакупки * ПолучитьНалогОрганизации(Объект.Организация) / 120;
	Иначе
		ТекДанные.СуммаНДС = 0;
	КонецЕсли;
	ТекДанные.ЦенаВЗаказНаряде = (ТекДанные.СуммаЗакупки - ТекДанные.СуммаНДС) / ТекДанные.Количество;
	
	ТекДанные.Прибыль = (ТекДанные.ЦенаПродажи * ТекДанные.Количество) - ТекДанные.СуммаЗакупки;
КонецПроцедуры


&НаКлиенте
Процедура ЗакупленныйТоварЦенаЗакупкиПриИзменении(Элемент)
	
		
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Для Каждого СтрокаТЧ Из Объект.ЗакупленныйТовар Цикл
		СтрокаТЧ.СуммаНДС = (СтрокаТЧ.СуммаЗакупки) * ПолучитьНалогОрганизации(Объект.Организация) / 120;
		СтрокаТЧ.ЦенаВЗаказНаряде = (СтрокаТЧ.СуммаЗакупки - СтрокаТЧ.СуммаНДС) / СтрокаТЧ.Количество;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗакупленныйТоварСуммаЗакупкиПриИзменении(Элемент)
	ТекДанные = Элементы.ЗакупленныйТовар.ТекущиеДанные;
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекДанные.СуммаНДС = ТекДанные.СуммаЗакупки * ПолучитьНалогОрганизации(Объект.Организация) / 120;
	Иначе
		ТекДанные.СуммаНДС = 0;
	КонецЕсли;
	ТекДанные.ЦенаВЗаказНаряде = (ТекДанные.СуммаЗакупки - ТекДанные.СуммаНДС) / ТекДанные.Количество;
	ТекДанные.Прибыль = (ТекДанные.ЦенаПродажи * ТекДанные.Количество) - ТекДанные.СуммаЗакупки;
КонецПроцедуры



&НаКлиенте
Процедура ЗакупленныйТоварТоварПриИзменении(Элемент)
	ТекДанные = Элементы.ЗакупленныйТовар.ТекущиеДанные;
	ДанныеОТоваре = ПолучитьДанныеТовара(ТекДанные.Товар);
	ТекДанные.Код = ДанныеОТоваре.Код;
	ТекДанные.Артикул = ДанныеОТоваре.Артикул;
	ТекДанные.Производитель = ДанныеОТоваре.Производитель;
	ТекДанные.Количество = 1;
	ТекДанные.ЦенаПродажи = ДанныеОТоваре.ЦенаПродажи;
	ТекДанные.Прибыль = (ТекДанные.ЦенаПродажи * ТекДанные.Количество) - ТекДанные.СуммаЗакупки;
	ТекДанные.СтатусПоступления = ПолучитьСтатусОжидаем();
КонецПроцедуры

&НаКлиенте
Процедура ЗакупленныйТоварПрибыльПриИзменении(Элемент)
	//TODO: Вставить содержимое обработчика
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
	Объект.Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ЗакупленныйТоварПриИзменении(Элемент)
	Объект.СуммаДокумента = Объект.ЗакупленныйТовар.Итог("СуммаЗакупки")
КонецПроцедуры

Функция ПолучитьНалогОрганизации(Организация)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Организация.Налог КАК Налог
	|ИЗ
	|	Справочник.Организация КАК Организация
	|ГДЕ
	|	Организация.Ссылка = &Организация";

	Запрос.УстановитьПараметр("Организация", Организация);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	ВыборкаДетальныеЗаписи.Следующий();
	Возврат Число(ВыборкаДетальныеЗаписи.Налог);
КонецФункции




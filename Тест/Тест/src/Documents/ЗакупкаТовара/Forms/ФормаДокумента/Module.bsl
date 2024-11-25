
&НаКлиенте
Процедура ЗакупленныйТоварТоварПриИзменении(Элемент)
	ТекДанные = Элементы.ЗакупленныйТовар.ТекущиеДанные;
	ДанныеОТоваре = ПолучитьДанныеТовара(ТекДанные.Товар);
	ТекДанные.Код = ДанныеОТоваре.Код;
	ТекДанные.Артикул = ДанныеОТоваре.Артикул;
	ТекДанные.Производитель = ДанныеОТоваре.Производитель;
	ТекДанные.Количество = 1;
	ТекДанные.ЦенаПродажи = ДанныеОТоваре.ЦенаПродажи;
	ТекДанные.СтатусПоступления = ПредопределенноеЗначение("Перечисление.СтатусЗакупкиТовара.ОжидаемПоступление");
КонецПроцедуры

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
	ТекДанные.СуммаЗакупки = ТекДанные.ЦенаЗакупки * ТекДанные.Количество;
	ТекДанные.Прибыль = (ТекДанные.ЦенаПродажи * ТекДанные.Количество) - (ТекДанные.ЦенаЗакупки * ТекДанные.Количество);
КонецПроцедуры


&НаКлиенте
Процедура ЗакупленныйТоварЦенаЗакупкиПриИзменении(Элемент)
		ТекДанные = Элементы.ЗакупленныйТовар.ТекущиеДанные;
		ТекДанные.Прибыль = (ТекДанные.ЦенаПродажи * ТекДанные.Количество) - (ТекДанные.ЦенаЗакупки * ТекДанные.Количество);
		ТекДанные.СуммаЗакупки = ТекДанные.ЦенаЗакупки * ТекДанные.Количество;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ЗакупленныйТоварПриИзменении(Элемент)
	Объект.СуммаДокумента = Объект.ЗакупленныйТовар.Итог("СуммаЗакупки")
КонецПроцедуры






&НаКлиенте
Процедура СоздатьДокументЗакупка(Команда)
/// Комлев АА 25/11/24 +++
	ОткрытьФорму("Документ.ЗакупкаТовара.ФормаСписка");
	ФормаЗакупка = ОткрытьФорму("Документ.ЗакупкаТовара.Форма.ФормаДокумента");
	ФормаЗакупка.Объект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	ФормаЗакупка.ОбновитьОтображениеДанных();
/// Комлев АА 25/11/24 ---
КонецПроцедуры

&НаКлиенте
Процедура ФильтрПриИзменении(Элемент)
	Если Фильтр = 1 Тогда
		ТекстЗапросаОжидаем();
	ИначеЕсли Фильтр = 2 Тогда
		ТекстЗапросаПоступил();
	ИначеЕсли Фильтр = 3 Тогда
		ТекстЗапросаВсеТовары();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Оприходовать(Команда)
	/// Комлев АА 25/11/24 +++
	МассивВыбранныхСтрок = Новый Массив;
	Для Каждого Строка Из Элементы.СписокЗакупленногоТовара.ВыделенныеСтроки Цикл
		МассивВыбранныхСтрок.Добавить(Строка);
	КонецЦикла;

	Если МассивВыбранныхСтрок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Элементы.СписокЗакупленногоТовара.ТекущаяСтрока = 0;
	ПервыйЭлемент = Элементы.СписокЗакупленногоТовара.ТекущиеДанные;
	Для Каждого Элемент Из МассивВыбранныхСтрок Цикл
		Элементы.СписокЗакупленногоТовара.ТекущаяСтрока = Элемент;
		НужныеМнеДанные = Элементы.СписокЗакупленногоТовара.ТекущиеДанные;
		Если ПервыйЭлемент.Поставщик <> НужныеМнеДанные.Поставщик Тогда
			Сообщить("Выбраны разные Поставщики");
			Возврат;
		КонецЕсли;
	КонецЦикла;

	ФормаПоступления = ОткрытьФорму("Документ.ПоступлениеЗапчастей.Форма.ФормаДокумента");
	ФормаПоступления.Объект.Новые = Истина;

	Для Каждого Элемент Из МассивВыбранныхСтрок Цикл
		Элементы.СписокЗакупленногоТовара.ТекущаяСтрока = Элемент;
		НужныеМнеДанные = Элементы.СписокЗакупленногоТовара.ТекущиеДанные;
		ФормаПоступления.Объект.Поставшик = НужныеМнеДанные.Поставщик;
		Счетчик = НужныеМнеДанные.Количество;
		Пока Счетчик > 0 Цикл
			СтрокаТЧ = ФормаПоступления.Объект.Таблица.Добавить();
			СтрокаТЧ.Товар = НужныеМнеДанные.Товар;
			ДанныеЗаполнения = Новый Структура;
			ДанныеЗаполнения.Вставить("Номенклатура", СтрокаТЧ.Товар);
			ДанныеЗаполнения.Вставить("Автомобиль", СтрокаТЧ.Автомобиль);
			СтрокаТЧ.Партия = ЗаполнитьПартии(ДанныеЗаполнения);
			//СтрокаТЧ.Код = НужныеМнеДанные.Код;
			СтрокаТЧ.Колво = 1;
			Если ТипЗнч(НужныеМнеДанные.НазначениеДетали) = Тип("ДокументСсылка.ПродажаЗапчастей") Тогда
				СтрокаТЧ.Продажа = НужныеМнеДанные.НазначениеДетали;
			ИначеЕсли ТипЗнч(НужныеМнеДанные.НазначениеДетали) = Тип("СправочникСсылка.ПроектыРазработки") Тогда 
				СтрокаТЧ.Проект = НужныеМнеДанные.НазначениеДетали;
			КонецЕсли;
			СтрокаТЧ.Цена = НужныеМнеДанные.ЦенаПродажи;
			СтрокаТЧ.СуммаПоступления = НужныеМнеДанные.СуммаЗакупки;
			СтрокаТЧ.ЦенаПоступления = НужныеМнеДанные.СуммаЗакупки / СтрокаТЧ.Колво;
			СтрокаТЧ.ДатаДобавления = ТекущаяДата();
			СтрокаТЧ.ДокументЗакупкаТовара = НужныеМнеДанные.ЗаказДеталей;
			Счетчик = Счетчик - 1;
		КонецЦикла;

	КонецЦикла;
	/// Комлев АА 25/11/24 ---
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаполнитьПартии(ДанныеЗаполнения, Отказ = Ложь)
	ИндКод = Справочники.ИндКод.СоздатьНовыйЭлемент(ДанныеЗаполнения, Отказ);
	Возврат ИндКод;
КонецФункции



Процедура ТекстЗапросаПоступил()
	/// Комлев АА 25/11/24 +++
	Текст = "ВЫБРАТЬ
			|	ЗакупкаТовараЗакупленныйТовар.Товар,
			|	ЗакупкаТовараЗакупленныйТовар.Код,
			|	ЗакупкаТовараЗакупленныйТовар.Артикул,
			|	ЗакупкаТовараЗакупленныйТовар.Производитель,
			|	ЗакупкаТовараЗакупленныйТовар.Ссылка КАК ЗаказДеталей,
			|	ЗакупкаТовараЗакупленныйТовар.Ссылка.Поставщик,
			|	ЗакупкаТовараЗакупленныйТовар.НазначениеДетали,
			|	ЗакупкаТовараЗакупленныйТовар.Количество,
			|	ЗакупкаТовараЗакупленныйТовар.ЦенаЗакупки,
			|	ЗакупкаТовараЗакупленныйТовар.ЦенаПродажи,
			|	ЗакупкаТовараЗакупленныйТовар.Прибыль,
			|	ЗакупкаТовараЗакупленныйТовар.СуммаЗакупки,
			|	ЗакупкаТовараЗакупленныйТовар.СтатусПоступления
			|ИЗ
			|	Документ.ЗакупкаТовара.ЗакупленныйТовар КАК ЗакупкаТовараЗакупленныйТовар
			|ГДЕ
			|	ЗакупкаТовараЗакупленныйТовар.СтатусПоступления = ЗНАЧЕНИЕ(Перечисление.СтатусЗакупкиТовара.Поступил)";

	СписокЗакупленногоТовара.ПроизвольныйЗапрос = Истина;
	СписокЗакупленногоТовара.ТекстЗапроса = Текст;

	Элементы.СписокЗакупленногоТовара.Обновить();
	/// Комлев АА 25/11/24 ---
КонецПроцедуры

Процедура ТекстЗапросаОжидаем()
	/// Комлев АА 25/11/24 +++
	Текст = "ВЫБРАТЬ
			|	ЗакупкаТовараЗакупленныйТовар.Товар,
			|	ЗакупкаТовараЗакупленныйТовар.Код,
			|	ЗакупкаТовараЗакупленныйТовар.Артикул,
			|	ЗакупкаТовараЗакупленныйТовар.Производитель,
			|	ЗакупкаТовараЗакупленныйТовар.Ссылка КАК ЗаказДеталей,
			|	ЗакупкаТовараЗакупленныйТовар.Ссылка.Поставщик,
			|	ЗакупкаТовараЗакупленныйТовар.НазначениеДетали,
			|	ЗакупкаТовараЗакупленныйТовар.Количество,
			|	ЗакупкаТовараЗакупленныйТовар.ЦенаЗакупки,
			|	ЗакупкаТовараЗакупленныйТовар.ЦенаПродажи,
			|	ЗакупкаТовараЗакупленныйТовар.Прибыль,
			|	ЗакупкаТовараЗакупленныйТовар.СуммаЗакупки,
			|	ЗакупкаТовараЗакупленныйТовар.СтатусПоступления
			|ИЗ
			|	Документ.ЗакупкаТовара.ЗакупленныйТовар КАК ЗакупкаТовараЗакупленныйТовар
			|ГДЕ
			|	ЗакупкаТовараЗакупленныйТовар.СтатусПоступления = ЗНАЧЕНИЕ(Перечисление.СтатусЗакупкиТовара.ОжидаемПоступление)";

	СписокЗакупленногоТовара.ПроизвольныйЗапрос = Истина;
	СписокЗакупленногоТовара.ТекстЗапроса = Текст;

	Элементы.СписокЗакупленногоТовара.Обновить();
	/// Комлев АА 25/11/24 ---
КонецПроцедуры

Процедура ТекстЗапросаВсеТовары()
	/// Комлев АА 03/12/24 +++
	Текст = "ВЫБРАТЬ
			|	ЗакупкаТовараЗакупленныйТовар.Товар,
			|	ЗакупкаТовараЗакупленныйТовар.Код,
			|	ЗакупкаТовараЗакупленныйТовар.Артикул,
			|	ЗакупкаТовараЗакупленныйТовар.Производитель,
			|	ЗакупкаТовараЗакупленныйТовар.Ссылка КАК ЗаказДеталей,
			|	ЗакупкаТовараЗакупленныйТовар.Ссылка.Поставщик,
			|	ЗакупкаТовараЗакупленныйТовар.НазначениеДетали,
			|	ЗакупкаТовараЗакупленныйТовар.Количество,
			|	ЗакупкаТовараЗакупленныйТовар.ЦенаЗакупки,
			|	ЗакупкаТовараЗакупленныйТовар.ЦенаПродажи,
			|	ЗакупкаТовараЗакупленныйТовар.Прибыль,
			|	ЗакупкаТовараЗакупленныйТовар.СуммаЗакупки,
			|	ЗакупкаТовараЗакупленныйТовар.СтатусПоступления
			|ИЗ
			|	Документ.ЗакупкаТовара.ЗакупленныйТовар КАК ЗакупкаТовараЗакупленныйТовар";

	СписокЗакупленногоТовара.ПроизвольныйЗапрос = Истина;
	СписокЗакупленногоТовара.ТекстЗапроса = Текст;

	Элементы.СписокЗакупленногоТовара.Обновить();
	/// Комлев АА 03/12/24 ---
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Фильтр = 1;
КонецПроцедуры


&НаКлиенте
Процедура СписокЗакупленногоТовараВыбор1(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
/// Комлев АА 25/11/24 ---
	Если Поле = Элементы.СписокЗакупленногоТовараЗаказДеталей Тогда
		СтандартнаяОбработка = Ложь;
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.ЗаказДеталей);
			ОткрытьФорму("Документ.ЗакупкаТовара.Форма.ФормаДокумента", ПараметрыФормы);
		КонецЕсли;
	ИначеЕсли Поле = Элементы.СписокЗакупленногоТовараТовар Тогда
		СтандартнаяОбработка = Ложь;
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Товар);
			ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлемента", ПараметрыФормы);
		КонецЕсли;
		Элементы.СписокЗакупленногоТовара.Обновить();
	КонецЕсли;
	/// Комлев АА 25/11/24 ---
КонецПроцедуры

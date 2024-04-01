
// Клиент
&НаКлиенте
Перем мШиринаКолонокПоУмолчанию;

&НаКлиенте
Перем мСтрокаПеретаскивания;


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТонкийКлиент();
	мШиринаКолонокПоУмолчанию = 15;
	ИнициализироватьДеревоЗапросов();
	СоставРезультатов = 1;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	СохранитьНаработки();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКонструкторЗапроса(Команда)
	#Если ТолстыйКлиентУправляемоеПриложение ИЛИ ТолстыйКлиентОбычноеПриложение Тогда
	ЭлементДерева = Элементы.ДеревоЗапросов.ТекущиеДанные;
	Если ЭлементДерева <> Неопределено Тогда
		Если ЗначениеЗаполнено(ЭлементДерева.ТекстЗапроса) Тогда
			Конструктор = Новый КонструкторЗапроса(ЭлементДерева.ТекстЗапроса);
		Иначе
			Конструктор = Новый КонструкторЗапроса();
		КонецЕсли;
		Если Конструктор.ОткрытьМодально() Тогда
			ЭлементДерева.ТекстЗапроса = Конструктор.Текст;
		Иначе
			Модифицированность = Ложь;
		КонецЕсли;
	Иначе
		Предупреждение("Запрос не выбран");
		Модифицированность = Ложь;
 	КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ТонкийКлиент()
	#Если ТонкийКлиент ИЛИ ВебКлиент Тогда
	Заголовок = Заголовок + " (тонкий клиент)";
	Элементы.ОткрытьКонструктор.Доступность = Ложь; 
	Элементы.ОткрытьКонструкторИзКонтекстногоМеню.Доступность = Ложь;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьДеревоЗапросов(Команда = Неопределено)
	СохранитьНаработки();
	ПутьКФайлу = "";
	Запросы = ДеревоЗапросов.ПолучитьЭлементы();
	Запросы.Очистить();
	ИнициализироватьЗапрос(Запросы.Добавить(), "Запросы");
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапрос(Команда)
	ЭлементДерева = Элементы.ДеревоЗапросов.ТекущиеДанные;
	Если ЭлементДерева <> Неопределено Тогда
		ПараметрыЗапроса = ЭлементДерева.ПараметрыЗапроса;
		ВыполнитьТекстЗапроса(ЭлементДерева.ТекстЗапроса, ПараметрыЗапроса, ЭлементДерева.СпособВыгрузки);
	Иначе
		Предупреждение("Запрос не выбран");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлЗапросов(Команда)
	СохранитьНаработки();
	Диалог = ПолучитьДиалогВыбораФайла();
	Если Диалог.Выбрать() Тогда
		ПутьКФайлу = Диалог.ПолноеИмяФайла;
		ВызовПолучитьДерево(ПередатьНаСервер(ПутьКФайлу), мШиринаКолонокПоУмолчанию); 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлЗапросов(Команда = Неопределено)
	Если НЕ ЗначениеЗаполнено(ПутьКФайлу) Тогда
		Диалог = ПолучитьДиалогВыбораФайла();
		Если Диалог.Выбрать() Тогда
			ПутьКФайлу = Диалог.ПолноеИмяФайла;	
			ПреобразоватьИСохранитьДерево(ПутьКФайлу);
			Модифицированность = Ложь;
		КонецЕсли;
	Иначе
		ПреобразоватьИСохранитьДерево(ПутьКФайлу);
		Модифицированность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЗапрос(Команда)
	ГридДереваЗапросов = Элементы.ДеревоЗапросов;
	ТекущийЗапрос = ГридДереваЗапросов.ТекущиеДанные;
	Если ТекущийЗапрос <> Неопределено Тогда
		ГридДереваЗапросов.ДобавитьСтроку();
		НовыйЗапрос = ГридДереваЗапросов.ТекущиеДанные;
		ИнициализироватьЗапрос(НовыйЗапрос, "<без названия>");
		Модифицированность = Истина;
	Иначе
		Предупреждение("Запрос-родитель не выбран");
		Модифицированность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьЗапрос(Команда)
	ГридЗапросов = Элементы.ДеревоЗапросов;
	ТекущийЗапрос = ГридЗапросов.ТекущиеДанные;
	Если ТекущийЗапрос <> Неопределено Тогда
		РодительТекущего = ТекущийЗапрос.ПолучитьРодителя();
		Если РодительТекущего <> Неопределено Тогда
			НовыйЗапрос = РодительТекущего.ПолучитьЭлементы().Добавить();
			СкопироватьСтрокуДереваЗапросов(НовыйЗапрос, ТекущийЗапрос);
			ГридЗапросов.ТекущаяСтрока = НовыйЗапрос.ПолучитьИдентификатор();
		Иначе
			Предупреждение("Нельзя скопировать корневой элемент");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗапрос(Команда)
	ТекущийЗапрос = Элементы.ДеревоЗапросов.ТекущиеДанные;
	Если ТекущийЗапрос <> Неопределено Тогда
		Родитель = ТекущийЗапрос.ПолучитьРодителя();
		Если Родитель <> Неопределено Тогда
			Родитель.ПолучитьЭлементы().Удалить(ТекущийЗапрос);
		Иначе
			Предупреждение("Нельзя удалить корневой элемент");
			Модифицированность = Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗапросВверх(Команда)
	СдвинутьЗапрос(-1);
КонецПроцедуры

&НаКлиенте
Процедура ЗапросВниз(Команда)
	СдвинутьЗапрос(1);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметры(Команда)
	ТекущиеДанные = Элементы.ДеревоЗапросов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ЗначениеВозврата = ВызовЗаполнитьПараметры(ТекущиеДанные.ПолучитьИдентификатор());
		Если ТипЗнч(ЗначениеВозврата) = Тип("Структура") Тогда
			ТекущиеДанные.ПараметрыЗапроса.Очистить();
			Для каждого ПараметрЗапроса из ЗначениеВозврата Цикл
				НовыйПараметр = ТекущиеДанные.ПараметрыЗапроса.Добавить();
				НовыйПараметр.ИмяПараметра = ПараметрЗапроса.Ключ;
				НовыйПараметр.ЗначениеПараметра = ПараметрЗапроса.Значение.ПривестиЗначение(НовыйПараметр.ЗначениеПараметра);
			КонецЦикла;
		Иначе
			Сообщить(ЗначениеВозврата);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьРезультат(Команда)
	Если ПолеРезультатаЗапроса.ВысотаТаблицы > 0 Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		Диалог.Фильтр = "Файл Excel (*.xls)|*.xls|Табличный документ (*.mxl)|*.mxl";
		Если Диалог.Выбрать() Тогда
			Файл = Новый Файл(Диалог.ПолноеИмяФайла);
			Если Файл.Расширение = ".mxl" Тогда
				ТипФайла = ТипФайлаТабличногоДокумента.MXL;
			ИначеЕсли Файл.Расширение = ".xls" Тогда
				ТипФайла = ТипФайлаТабличногоДокумента.XLS;
			КонецЕсли;
			ПолеРезультатаЗапроса.Записать(Диалог.ПолноеИмяФайла, ТипФайла);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	Диалог = ПолучитьДиалогВыбораФайла();
	Если Диалог.Выбрать() Тогда
		Путь = Диалог.ПолноеИмяФайла;	
		Проверка = Новый Файл(Путь);
		Если Проверка.Существует() Тогда
			Если Вопрос("Файл '" + Путь + "' существует. Заменить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
				ПреобразоватьИСохранитьДерево(Путь);
				ПутьКФайлу = Путь;
			КонецЕсли;
		Иначе
			ПреобразоватьИСохранитьДерево(Путь);
			ПутьКФайлу = Путь;
		КонецЕсли;
		Модифицированность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыделенныйТекст(Команда)
	ЭлементДерева = Элементы.ДеревоЗапросов.ТекущиеДанные;
	Если ЭлементДерева <> Неопределено Тогда
		ПараметрыЗапроса = ЭлементДерева.ПараметрыЗапроса;
		ВыполнитьТекстЗапроса(Элементы.ТекстЗапроса.ВыделенныйТекст, ПараметрыЗапроса, 1);
	Иначе
		Предупреждение("Запрос должен быть выделен в дереве");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КакПереподчинить(Команда)
	Предупреждение("Для изменения подчиненности просто перетащите элемент мышью на нового родителя");
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьРезультат(Команда)
	ПолеРезультатаЗапроса = Новый ТабличныйДокумент();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТекстЗапроса(Команда)
	ТекущиеДанные = Элементы.ДеревоЗапросов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.ТекстЗапроса = "";
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолеРезультатаЗапросаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	Если ТипЗнч(Расшифровка) = Тип("ТабличныйДокумент") Тогда
		СтандартнаяОбработка = Ложь;
		ФормаВложеннойТаблицы = ПолучитьФорму(ПутьКФормам + "ФормаВложеннойТаблицы");
		ФормаВложеннойТаблицы.ВладелецФормы                 = ЭтаФорма;
		ФормаВложеннойТаблицы.ЗакрыватьПриЗакрытииВладельца = Истина;
		ФормаВложеннойТаблицы.ШиринаКолонок                 = мШиринаКолонокПоУмолчанию;
		ФормаВложеннойТаблицы.ВложеннаяТаблица              = Расшифровка;
		ФормаВложеннойТаблицы.ВложеннаяТаблица.Область().ШиринаКолонки = мШиринаКолонокПоУмолчанию;
		ФормаВложеннойТаблицы.Открыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИмяЗапросаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТекстЗапросаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолеШиринаКолонокРегулирование(Элемент)
	УстановитьШиринуКолонок();
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СпособВыгрузкиПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначениеПараметраОчистка(Элемент, СтандартнаяОбработка)
	Элементы.СписокПараметров.ТекущиеДанные.ЗначениеПараметра = Неопределено;
	Элемент.ВыбиратьТип  = Истина;
	Элемент.КнопкаВыбора = Истина;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначениеПараметраПриИзменении(Элемент)
	ТекущееОписание = Элементы.СписокПараметров.ТекущиеДанные;
	Значение = ТекущееОписание.ЗначениеПараметра;
	Если ТипЗнч(Значение) = Тип("ОписаниеТипов") Тогда
		ЗаданныеТипы = Значение.Типы();
		Если ЗаданныеТипы.Количество() > 1 Тогда
			МассивТипов = Новый Массив();
			МассивТипов.Добавить(ЗаданныеТипы[0]);
			ТекущееОписание.ЗначениеПараметра = Новый ОписаниеТипов(МассивТипов);
			Предупреждение("Задан составной тип. Будет использован первый из состава типов");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПараметровПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущиеДанные.ЗначениеПараметра = Неопределено Тогда
		Элемент.ТекущийЭлемент.ВыбиратьТип = Истина;
	Иначе
		Элемент.ТекущийЭлемент.ВыбиратьТип = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЗапросовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	мСтрокаПеретаскивания = Элемент.ТекущиеДанные;
	ПараметрыПеретаскивания.Значение = "";
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЗапросовПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЗапросовПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Если Строка <> Неопределено Тогда
		НовыйРодитель = ДеревоЗапросов.НайтиПоИдентификатору(Строка);
		Потомок = мСтрокаПеретаскивания;
		ПрежнийРодитель = Потомок.ПолучитьРодителя();
		Если НЕ ((ПрежнийРодитель = Неопределено) ИЛИ (Строка = ПрежнийРодитель.ПолучитьИдентификатор())) Тогда
			Если НЕ ВИерархии(НовыйРодитель, Потомок) Тогда
				Если Вопрос("Переподчинить элемент """ + Потомок.Запрос + """ элементу """ + НовыйРодитель.Запрос + """?", 
						РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
					Подчинить(Потомок, НовыйРодитель.ПолучитьЭлементы());
					ПрежняяСемья = ПрежнийРодитель.ПолучитьЭлементы();
					ПрежняяСемья.Удалить(ПрежняяСемья.Индекс(Потомок));
					Модифицированность = Истина;
				КонецЕсли;
			Иначе
				Предупреждение("Зацикливание подчиненности - переподчинение невозможно");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтрокуДереваЗапросов(НовыйЗапрос, ТекущийЗапрос)
	ЗаполнитьЗначенияСвойств(НовыйЗапрос, ТекущийЗапрос, , "ПараметрыЗапроса");
	ПараметрыТекущего = ТекущийЗапрос.ПараметрыЗапроса;
	ПараметрыНового = НовыйЗапрос.ПараметрыЗапроса;
	Для каждого СтрокаПараметр из ПараметрыТекущего Цикл
		СтрокаПараметрНового = ПараметрыНового.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПараметрНового, СтрокаПараметр);
	КонецЦикла;
	ДочерниеЗапросы = ТекущийЗапрос.ПолучитьЭлементы();
	ДочерниеЗапросыНового = НовыйЗапрос.ПолучитьЭлементы();
	Для каждого ДочернийЗапрос из ДочерниеЗапросы Цикл;
		НовыйДочернийЗапрос = ДочерниеЗапросыНового.Добавить();
		СкопироватьСтрокуДереваЗапросов(НовыйДочернийЗапрос, ДочернийЗапрос);
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура ВыполнитьТекстЗапроса(ТекстЗапроса, ПараметрыЗапроса, СпособВыгрузки)
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
		ПолеРезультатаЗапроса = Новый ТабличныйДокумент();
		Результат = ВызовВыполнитьЗапрос(ТекстЗапроса, ПараметрыЗапроса, СпособВыгрузки);
		Если ТипЗнч(Результат) = Тип("ТабличныйДокумент") Тогда
			ПолеРезультатаЗапроса = Результат;
			Элементы.ПолеРезультатаЗапроса.ТекущаяОбласть = Результат.Область(1, 1, 1, 1);
			УстановитьШиринуКолонок();
		Иначе
			Сообщить(Результат);
		КонецЕсли;
	Иначе
		Предупреждение("Текст запроса пустой");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьШиринуКолонок()
	ТекущиеДанные = Элементы.ДеревоЗапросов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ШиринаКолонок = ТекущиеДанные.ШиринаКолонок;
		Если ШиринаКолонок > 0 Тогда
			ПолеРезультатаЗапроса.Область().ШиринаКолонки = ШиринаКолонок;
		Иначе
			ПолеРезультатаЗапроса.Область().ШиринаКолонки = мШиринаКолонокПоУмолчанию;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДиалогВыбораФайла()
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок  = "Выберите файл со списком запросов";
	Диалог.Фильтр     = "Файлы запросов (*.sel)|*.sel|Все файлы (*.*)|*.*";
	Диалог.Расширение = "sel";
	Возврат Диалог;
КонецФункции

&НаКлиенте
Процедура СохранитьНаработки()
	Если Модифицированность Тогда
		Если Вопрос("Сохранить файл запросов?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			СохранитьФайлЗапросов();
		Иначе
			Модифицированность = Ложь;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьЗапрос(ЭлементДереваЗапросов, ИмяЗапроса = "")
	ЭлементДереваЗапросов.Запрос         = ИмяЗапроса;
	ЭлементДереваЗапросов.ТекстЗапроса   = "";
	ЭлементДереваЗапросов.СпособВыгрузки = 1;
	ЭлементДереваЗапросов.ШиринаКолонок  = мШиринаКолонокПоУмолчанию;
КонецПроцедуры

&НаКлиенте
Процедура СдвинутьЗапрос(Направление)
	ТекущийЗапрос = Элементы.ДеревоЗапросов.ТекущиеДанные;
	Если ТекущийЗапрос <> Неопределено Тогда
		Родитель = ТекущийЗапрос.ПолучитьРодителя();
		Если Родитель <> Неопределено Тогда
			Семейство = Родитель.ПолучитьЭлементы();
			Индекс = Семейство.Индекс(ТекущийЗапрос);
			Если ((Направление = 1) И (Индекс < Семейство.Количество() - 1)) 
				ИЛИ ((Направление = -1) И (Индекс > 0)) Тогда
					Семейство.Сдвинуть(Индекс, Направление);
					Модифицированность = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПреобразоватьИСохранитьДерево(ПутьКФайлу)
	АдресХранилища = ВызовПреобразоватьДерево();
	ПолучитьФайл(АдресХранилища, ПутьКФайлу, Ложь);
	УдалитьИзВременногоХранилища(АдресХранилища);
КонецПроцедуры

&НаКлиенте
Функция ВИерархии(НовыйРодитель, Потомок)
	ПредокНовогоРодителя = НовыйРодитель.ПолучитьРодителя();
	Проверять = Истина;
	Результат = Ложь;
	Пока Проверять Цикл
		Если ПредокНовогоРодителя <> Неопределено Тогда
			Если ПредокНовогоРодителя = Потомок Тогда
				Проверять = Ложь;
				Результат = Истина;
			Иначе
				ПредокНовогоРодителя = ПредокНовогоРодителя.ПолучитьРодителя();
			КонецЕсли;
		Иначе
			Проверять = Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура Подчинить(Потомок, НоваяСемья)
	НоваяСтрока = НоваяСемья.Добавить();
	НоваяСтрока.Запрос         = Потомок.Запрос;
	НоваяСтрока.ТекстЗапроса   = Потомок.ТекстЗапроса;
	НоваяСтрока.СпособВыгрузки = Потомок.СпособВыгрузки;
	НоваяСтрока.ШиринаКолонок  = Потомок.ШиринаКолонок;
	СкопироватьПараметры(НоваяСтрока.ПараметрыЗапроса, Потомок.ПараметрыЗапроса);
	ПотомкиПотомка = Потомок.ПолучитьЭлементы();
	Для Каждого ПотомокПотомка из ПотомкиПотомка Цикл
		Подчинить(ПотомокПотомка, НоваяСтрока.ПолучитьЭлементы());
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьПараметры(ТаблицаПриемник, ТаблицаИсточник)
	Для каждого СтрокаИсточник из ТаблицаИсточник Цикл
		НоваяСтрока = ТаблицаПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсточник);
	КонецЦикла;
КонецПроцедуры 

&НаКлиенте
Функция ПередатьНаСервер(ПутьКФайлу)
	Перем АдресХранилища;
	
	ПоместитьФайл(АдресХранилища, ПутьКФайлу, ПутьКФайлу, Ложь, УникальныйИдентификатор);
	Возврат АдресХранилища;
КонецФункции

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПутьКФормам = ПолучитьОбработку().Метаданные().ПолноеИмя() + ".Форма.";
КонецПроцедуры

&НаСервере
Функция ВызовВыполнитьЗапрос(ТекстЗапроса, ПараметрыЗапроса, СпособВыгрузки)
	Возврат ПолучитьОбработку().ВыполнитьЗапрос(ТекстЗапроса, ПараметрыЗапроса, СпособВыгрузки, СоставРезультатов, ДляСсылокВыводитьГУИД);
КонецФункции

&НаСервере
Процедура ВызовПолучитьДерево(АдресХранилища, ШиринаКолонокПоУмолчанию)
	ПолучитьОбработку().ПолучитьДеревоИзФайла(АдресХранилища, ДеревоЗапросов, ШиринаКолонокПоУмолчанию);
КонецПроцедуры

&НаСервере
Функция ВызовПреобразоватьДерево()
	Возврат ПолучитьОбработку().ПреобразоватьДерево(ДеревоЗапросов);
КонецФункции

&НаСервере
Функция ВызовЗаполнитьПараметры(ИдентификаторТекущихДанных)
	Возврат ПолучитьОбработку().ЗаполнитьПараметрыЗапроса(ДеревоЗапросов, ИдентификаторТекущихДанных);
КонецФункции

&НаСервере
Функция ПолучитьОбработку()
	Возврат РеквизитФормыВЗначение("ОбработкаКонсольЗапросов");
КонецФункции




&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Установка порядка сортировки в списке по порядковому номеру
 Порядок=ЭтаФорма.Список.Порядок;
 Порядок.Элементы.Очистить();
 ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
 ЭлементПорядка.РежимОтображения =  РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
 ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
 ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Наименование"); // Поле, по которому будет упорядочивание
 ЭлементПорядка.Использование = Истина;
КонецПроцедуры

import QtQuick 2.13

Item {
    id: component
    property alias model: filterModel

    property QtObject sourceModel: undefined
    property string filter: ""
    property string property: ""

    Connections {
        onFilterChanged: invalidateFilter()
        onPropertyChanged: invalidateFilter()
        onSourceModelChanged: invalidateFilter()
    }

    Component.onCompleted: invalidateFilter()

    ListModel {
      id: filterModel
    }

    function invalidateFilter() {
        if (sourceModel === undefined)
            return;

        filterModel.clear();

        if (!isFilteringPropertyOk())
            return

        var length = sourceModel.count
        for (var i = 0; i < length; ++i) {
            var item = sourceModel.get(i);
            if (isAcceptedItem(item)) {
                filterModel.append(item)
            }
        }
    }


    function isAcceptedItem(item) {
        if (item[this.property] === undefined)
            return false

        let defaultCSS = 'p, li { white-space: pre-wrap; }';
        let filter = this.filter.replace(/<[^>]+>/g, '').replace(defaultCSS, '').trim();

        if (filter.endsWith("@")) {
          return true
        }

        let lastAt = filter.lastIndexOf("@")

        if (lastAt == -1) {
          return false
        }

        let filterWithoutAt = filter.substring(lastAt+1)

        if (filterWithoutAt == "") {
          return true
        }

        if (item[this.property].toLowerCase().match(filterWithoutAt.toLowerCase()) === null) {
            return false
        }

        return true
    }

    function isFilteringPropertyOk() {
        if(this.property === undefined || this.property === "") {
            return false
        }
        return true
    }
}




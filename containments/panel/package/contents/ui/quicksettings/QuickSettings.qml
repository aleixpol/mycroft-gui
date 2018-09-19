/*
 *   Copyright 2015 Marco Martin <notmart@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import QtQuick.Controls 2.2 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.5 as Kirigami

ColumnLayout {
    id: root

    signal delegateClicked

    function toggleAirplane() {
        print("toggle airplane mode")
    }

    spacing: units.largeSpacing
    property Controls.Drawer drawer

    Flow {
        id: flow
        Layout.alignment: Qt.AlignHCenter
       /* Layout.minimumHeight: implicitHeight
        Layout.preferredWidth: parent.width*/
        Layout.preferredWidth: (children.length * (delegateSize + Kirigami.Units.largeSpacing) < drawer.width)
                    ? implicitWidth : drawer.width
        Layout.minimumWidth: 0
        spacing: Kirigami.Units.largeSpacing

        property int delegateSize: Kirigami.Units.iconSizes.medium * 2 + Kirigami.Units.smallSpacing*2

        HomeDelegate {}
        DisableMycroftDelegate {}
        SystemSettingsDelegate {}
    }


    VolumeSlider {
        Layout.fillWidth: true
    }
    BrightnessSlider {
        Layout.fillWidth: true
    }
}

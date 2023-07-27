/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A layout that adapts to a changing layout environment
*/

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var listWindowController = ListWindowController(windowNibName: "ListWindow")
    private var gridWindowController = GridWindowController(windowNibName: "GridWindow")
    private var insetItemsGridWindowController = InsetItemsGridWindowController(windowNibName: "InsetItemsGridWindow")
    private var twoColumnWindowController = TwoColumnWindowController(windowNibName: "TwoColumnWindow")
    private var distinctSectionsWindowController = DistinctSectionsWindowController(
        windowNibName: "DistinctSectionsWindow")
    private var adaptiveSectionsWindowController = AdaptiveSectionsWindowController(
        windowNibName: "AdaptiveSectionsWindow")
    private var nestedGroupsWindowController = NestedGroupsWindowController(windowNibName: "NestedGroupsWindow")
    private var orthogonalScrollingWindowController = OrthogonalScrollingWindowController(
        windowNibName: "OrthogonalScrollingWindow")
    private var itemBadgeSupplementaryWindowController = ItemBadgeSupplementaryWindowController(
        windowNibName: "ItemBadgeSupplementaryWindow")
    private var sectionHeadersFootersWindowController = SectionHeadersFootersWindowController(
        windowNibName: "SectionHeadersFootersWindow")

    private var mountainsWindowController = MountainsWindowController(windowNibName: "MountainsWindow")
    private var wifiSettingsWindowController = WiFiSettingsWindowController(windowNibName: "WiFiSettingsWindow")
    private var insertionSortWindowController = InsertionSortWindowController(windowNibName: "InsertionSortWindow")

    // MARK: Actions

    @IBAction func showAllLayoutExamples(_ sender: Any?) {
        showList(sender)
        showGrid(sender)
        showInsetItemsGrid(sender)
        showTwoColumn(sender)
        showDistinctSections(sender)
        showAdaptiveSections(sender)
        showNestedGroups(sender)
        showOrthogonalScrolling(sender)
        showItemBadges(sender)
        showSectionHeadersFooters(sender)
    }

    @IBAction func showList(_ sender: Any?) {
        listWindowController.showWindow(sender)
    }

    @IBAction func showGrid(_ sender: Any?) {
        gridWindowController.showWindow(sender)
    }

    @IBAction func showInsetItemsGrid(_ sender: Any?) {
        insetItemsGridWindowController.showWindow(sender)
    }

    @IBAction func showTwoColumn(_ sender: Any?) {
        twoColumnWindowController.showWindow(sender)
    }

    @IBAction func showDistinctSections(_ sender: Any?) {
        distinctSectionsWindowController.showWindow(sender)
    }

    @IBAction func showAdaptiveSections(_ sender: Any?) {
        adaptiveSectionsWindowController.showWindow(sender)
    }

    @IBAction func showNestedGroups(_ sender: Any?) {
        nestedGroupsWindowController.showWindow(sender)
    }

    @IBAction func showOrthogonalScrolling(_ sender: Any?) {
        orthogonalScrollingWindowController.showWindow(sender)
    }

    @IBAction func showItemBadges(_ sender: Any?) {
        itemBadgeSupplementaryWindowController.showWindow(sender)
    }

    @IBAction func showSectionHeadersFooters(_ sender: Any?) {
        sectionHeadersFootersWindowController.showWindow(sender)
    }

    @IBAction func showAllDiffableDataSourceExamples(_ sender: Any?) {
        showMountains(sender)
        showWiFiSettings(sender)
        showInsertionSort(sender)
    }

    @IBAction func showMountains(_ sender: Any?) {
        mountainsWindowController.showWindow(sender)
    }

    @IBAction func showWiFiSettings(_ sender: Any?) {
        wifiSettingsWindowController.showWindow(sender)
    }

    @IBAction func showInsertionSort(_ sender: Any?) {
        insertionSortWindowController.showWindow(sender)
    }
}

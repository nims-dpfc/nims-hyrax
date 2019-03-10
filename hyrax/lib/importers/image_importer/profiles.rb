module Importers
  module ImageImporter
    module Profiles

      def profiles
        {
          "http://imeji.org/terms/statement/d79dc63-1739-47bf-8e7f-cfd0e89be517"=>["Description", 'text'],
          "http://imeji.org/terms/statement/d4c198d2-4988-4cf9-8daf-c91f310fccc7"=>["Date of editing", 'datetime'],
          "http://imeji.org/terms/statement/e6b94c1a-fae0-467b-9016-693c048eaf1d"=>["Date of exposure", 'datetime'],
          "http://imeji.org/terms/statement/b3a5545-34e1-4fdc-88bd-d843ba48360d"=>["Camera", 'text'],
          "http://imeji.org/terms/statement/c24d85ca-7229-4a02-b1f5-7149fafc9380"=>["Frame rate (fps)", 'number'],
          "http://imeji.org/terms/statement/e78050d-a3ce-4489-b7c0-fe8dc6fdb92b"=>["Exposure time (s)", 'text'],
          "http://imeji.org/terms/statement/af9d9a53-561a-46cb-bd2b-340f703b6c84"=>["Grayscale", 'number'],
          "http://imeji.org/terms/statement/c6d800a2-9549-40e8-8b27-7b8ebd943f76"=>["Image width (pixels)", 'number'],
          "http://imeji.org/terms/statement/effd334-55dd-422d-b2d6-61ca15042ee9"=>["Image height (pixels)", 'number'],
          "http://imeji.org/terms/statement/a7ea9bd-8879-41a6-be32-bbaeb3e1ad57"=>["Special thanks to", 'text'],
          "http://imeji.org/terms/statement/a83b2b-4633-4005-a9e2-76ab56425131"=>["Pump laser power (W)", 'number'],
          "http://imeji.org/terms/statement/dab5a85-ffa0-48b3-aa17-392e7e9b06d2"=>["Pump laser wavelength (nm)", 'number'],
          "http://imeji.org/terms/statement/aa6-fa80-454d-bdfb-62f4ce71c9b1"=>["Optical fiber", 'text'],
          "http://imeji.org/terms/statement/bseR9OmDancAl4N"=>["Diameter (μm)", 'number'],
          "http://imeji.org/terms/statement/ix7ptbU18Qn3T3S"=>["Coating", 'text'],
          "http://imeji.org/terms/statement/ce6f3620-0e9e-44d0-9c92-8c33e2e68e74"=>["Sample ID", 'text'],
          "http://imeji.nims.go.jp/statement/aUqgzpkZs9kdZyBg"=>["DOI", 'text'],
          "http://imeji.org/terms/statement/f56d9cc-1ff8-4f7c-a114-56ba0dbd1a8d"=>["References", 'uri'],
          "http://imeji.org/terms/statement/rjb2eKaIj5BeQgI0"=>["Box", 'text'],
          "http://imeji.org/terms/statement/T_t6dr7qYDhFKaJa"=>["License", 'license'],
          "http://imeji.org/terms/statement/yd7FyQI5t5f6DUbq"=>["Description", 'text'],
          "http://imeji.org/terms/statement/hr2cqGvvpogdco5d"=>["Left-hand view", 'text'],
          "http://imeji.org/terms/statement/670X2gSC8cnapC_b"=>["Right-hand view", 'text'],
          "http://imeji.org/terms/statement/Xn90gppBBxoQlWnk"=>["Date of exposure", 'datetime'],
          "http://imeji.org/terms/statement/T9yfGAPFcT3JXyB"=>["Camera", 'text'],
          "http://imeji.org/terms/statement/m8HUg6s0QyK2gmim"=>["Pump laser power (W)", 'number'],
          "http://imeji.org/terms/statement/NN11ensxqip4zP"=>["Pump laser wavelength (nm)", 'number'],
          "http://imeji.org/terms/statement/05FDlO_vI9VfCbd"=>["Optical fiber", 'text'],
          "http://imeji.org/terms/statement/4EWGWpQMHTFb47tH"=>["Diameter (μm)", 'number'],
          "http://imeji.org/terms/statement/VGOBbUXvty_fWpJL"=>["Coating", 'text'],
          "http://imeji.org/terms/statement/kHa0kVwOF9kV0mwm"=>["Propagation mode", 'text'],
          "http://imeji.org/terms/statement/53FiN9xSA7WjZjAQ"=>["Periodic void interval (μm)", 'number'],
          "http://imeji.org/terms/statement/C90WDA9YSnYgF4Hx"=>["Sample ID", 'text'],
          "http://imeji.org/terms/statement/4T9wCy69oZjUr9"=>["References", 'uri'],
          "http://imeji.org/terms/statement/hvfDwphfbqoYXgz"=>["Figure", 'number'],
          "http://imeji.org/terms/statement/xfFJn0ufoFh6Qal9"=>["License", 'license'],
          "http://imeji.nims.go.jp/statement/PVHZeQBnQ1TNkL5w"=>["Title", 'text'],
          "http://imeji.nims.go.jp/statement/a7PLt27_99t1MvY"=>["License", 'license'],
          "http://imeji.nims.go.jp/statement/oWx3iN5zaxHabFL"=>["Comment", 'text'],
          "http://imeji.nims.go.jp/statement/ahtgbeVZZRg2z2kT"=>["Article_URL", 'uri'],
          "http://imeji.nims.go.jp/statement/p5aUehASgFqOwK8X"=>["Item_DOI", 'uri'],
          "http://imeji.nims.go.jp/statement/gDv4odKsQ_HM5cii"=>["Article_DOI", 'uri'],
          "http://imeji.nims.go.jp/statement/A0w4Y4iX8yKlP95R"=>["link_to_nims_pubman", 'uri'],
          "http://imeji.nims.go.jp/statement/ajCcxL579Y1GmmwV"=>["Author", 'person'],
          "http://imeji.nims.go.jp/statement/3ZcWpPDJsQX9tgFI"=>["Journal", 'text'],
          "http://imeji.nims.go.jp/statement/B4Gl83PMc0BzRiS1"=>["Description", 'text'],
          "http://imeji.nims.go.jp/statement/Zo5jU0fOqx2rT8RV"=>["Date of exposure", 'datetime'],
          "http://imeji.nims.go.jp/statement/7gzVPscDA2o4WgEI"=>["Camera", 'text'],
          "http://imeji.nims.go.jp/statement/VDn7x1GtWoyxvl"=>["Pump laser power (W)", 'number'],
          "http://imeji.nims.go.jp/statement/UxVdWi4ia5iOQuJE"=>["Pump laser wavelength (μm)", 'number'],
          "http://imeji.nims.go.jp/statement/klwP8xv6aTr8o_0u"=>["Fusion splicer", 'text'],
          "http://imeji.nims.go.jp/statement/zBQBaXV77ovqUPXv"=>["Arc discharge intensity (%)", 'number'],
          "http://imeji.nims.go.jp/statement/SedhcvJzMZ2Nkvra"=>["Optical fiber", 'text'],
          "http://imeji.nims.go.jp/statement/eXK5nmUsodBGpTbr"=>["Diameter (μm)", 'number'],
          "http://imeji.nims.go.jp/statement/WrhQWykBRTROR8jB"=>["Coating", 'text'],
          "http://imeji.nims.go.jp/statement/ykjZiIT0YYlIcuJy"=>["Sample ID", 'text'],
          "http://imeji.nims.go.jp/statement/kvN4uekqe2hY3Se"=>["References", 'uri'],
          "http://imeji.nims.go.jp/statement/jDbC_kst6OD_PU8s"=>["Figure",'number'],
          "http://imeji.nims.go.jp/statement/6_4GsCMWUobPGCm5"=>["License", 'license'],
          'http://imeji.org/terms/statement/a8a3e41b-90c5-4a4d-9586-8cf099b94ab7'=>['Title', 'text'],
          'http://imeji.org/terms/statement/fa8b0a2-526e-427a-8461-4be32159b28e' => ['Name of substances', 'text'],
          'http://imeji.org/terms/statement/a9d30-a2b0-4a41-9099-45ac8237555f' => ['Solvent', 'text'],
          'http://imeji.org/terms/statement/e8e5-4a90-b0ef-ee3e78f609d7' => ['Wave length (nm)', 'number'],
          'http://imeji.org/terms/statement/d2088-d314-4017-9d03-fee124ba3381' => ['Light source', 'text'],
          'http://imeji.org/terms/statement/ae6f699-f0e1-45cd-b507-c88ac1aef395' => ['Temperature', 'number'],
          'http://imeji.org/terms/statement/c97edf0e-e878-4f65-94e9-0b6331ebea0b' => ['Date', 'datetime'],
          'http://imeji.org/terms/statement/d8d0dc6-7a1b-4265-b09a-bfa87902aec4' => ['References', 'uri']
          }
      end

      def mapped_properties
        {
          'Article_DOI' => 'related_item',
          'Article_URL' => 'related_item',
          'Author' => 'author',
          'Camera' => 'instrument',
          'Date' => 'date',
          'Description' => 'description',
          'DOI' => 'identifier',
          'Item_DOI' => 'identifier',
          'License' => 'license',
          'link_to_nims_pubman' => 'related_item',
          'References' => 'related_item',
          'Sample ID' => 'specimen_set',
          'Title' => 'title',
        }
      end

      def custom_propeties
        [
          'Arc discharge intensity (%)',
          'Box',
          'Coating',
          'Comment',
          'Diameter (μm)',
          'Exposure time (s)',
          'Figure',
          'Frame rate (fps)',
          'Fusion splicer',
          'Grayscale',
          'Image height (pixels)',
          'Image width (pixels)',
          'Journal',
          'Left-hand view',
          'Light source',
          'Name of substances',
          'Optical fiber',
          'Periodic void interval (μm)',
          'Propagation mode',
          'Pump laser power (W)',
          'Pump laser wavelength (nm)',
          'Pump laser wavelength (μm)',
          'Right-hand view',
          'Solvent',
          'Special thanks to',
          'Temperature',
          'Wave length (nm)'
        ]
      end
    end
  end
end












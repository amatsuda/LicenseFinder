require "xmlsimple"

module LicenseFinder
  class Maven
    def current_packages
      `mvn license:download-licenses`

      xml = license_report.read

      options = {
        'GroupTags' => { 'licenses' => 'license', 'dependencies' => 'dependency' },
        'ForceArray' => ['license', 'dependency']
      }
      dependencies = XmlSimple.xml_in(xml, options)["dependencies"]

      dependencies.map do |dep|
        MavenPackage.new(dep)
      end
    end

    def active?
      package_path.exist?
    end

    private

    def license_report
      Pathname.new('target/generated-resources/licenses.xml')
    end

    def package_path
      Pathname.new('pom.xml')
    end
  end
end

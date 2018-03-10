def examples_repositories():
    native.maven_jar(
        name="bndlib_artifact",
        artifact="biz.aQute.bnd:biz.aQute.bndlib:3.5.0",
    )

    native.maven_jar(
        name="osgi_core_artifact",
        artifact="org.osgi:org.osgi.core:6.0.0"
    )

    native.maven_jar(
        name="osgi_service_component_annotations_artifact",
        artifact="org.osgi:org.osgi.service.component.annotations:1.3.0"
    )

    native.maven_jar(
        name="osgi_service_tracker_collections_artifact",
        artifact="com.liferay:com.liferay.osgi.service.tracker.collections:2.0.0",
    )

    native.maven_jar(
        name="osgi_util_artifact",
        artifact="com.liferay:com.liferay.osgi.util:3.0.0",
    )

    native.maven_jar(
        name="portal_kernel_artifact",
        artifact="com.liferay.portal:com.liferay.portal.kernel:2.6.0",
    )

    native.maven_jar(
        name="portal_spring_extender_artifact",
        artifact="com.liferay:com.liferay.portal.spring.extender:2.0.0",
    )

    native.maven_jar(
        name="portlet_api_artifact",
        artifact="javax.portlet:portlet-api:2.0"
    )

    native.maven_jar(
        name="servlet_api_artifact",
        artifact="javax.servlet:servlet-api:2.5"
    )

    native.maven_jar(
        name="shiro_core_artifact",
        artifact="org.apache.shiro:shiro-core:1.1.0"
    )
